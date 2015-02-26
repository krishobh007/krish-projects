require 'RMagick'

class Staff::ReservationsController < ApplicationController
  before_filter :check_session, except: [:qr_code_image]
  after_filter :load_business_date_info
  before_filter :check_business_date

  def save_payment
    errors = []
    reservation = Reservation.find(params[:reservation_id]) if params[:reservation_id]
    bill_no = params[:bill_number] || 1
    hotel = reservation.andand.hotel || current_hotel
    attributes = ViewMappings::PaymentTypeMapping.map_payment_type(params)
    add_to_guest_card = params[:add_to_guest_card]
    account = Account.find(params[:account_id]) if params[:account_id]

    if params[:card_code].present?
      card_code = params[:card_code]
      # Check whether it is system defined one
      credit_card_type = Ref::CreditCardType[card_code.upcase.to_sym]

      # If the card_type is custom
      if credit_card_type.nil?
        custom_credit_card = PaymentType.where("hotel_id = ? AND UPPER(value) = ?", current_hotel.id, card_code.upcase).first
        attributes[:custom_payment_type] = custom_credit_card.andand.value
      end
    end

    if !params[:reservation_id] && !params[:account_id]
      # If no reservation_id passed, add the payment method without attaching to reservation or guest
      result = PaymentMethod.create_unassociated!(attributes, hotel)
      errors = result[:errors]
    elsif account.present?
      result = PaymentMethod.create_and_process!(account, hotel, attributes, nil)
      errors = result[:errors]
    else
      # Attach it to reservation
      bill = Bill.find_by_reservation_id_and_bill_number(reservation.id, bill_no)
      bill = reservation.bills.create(bill_number: 1) if !bill.present?
      result = PaymentMethod.create_on_reservation!(reservation, attributes, add_to_guest_card)
      errors = result[:errors]
      financial_records = bill.financial_transactions.where('financial_transactions.charge_code_id IS NOT NULL')
      bill_balance = financial_records.exclude_payment.sum(:amount).round(2) - financial_records.credit.sum(:amount).round(2)
    end


    if result && result[:payment_method]
      response_id = result[:payment_method].id
      credit_card_type = result[:payment_method][:credit_card_type_id] ? Ref::CreditCardType.find(result[:payment_method][:credit_card_type_id]).to_s : nil
      payment_method = PaymentType.find(result[:payment_method][:payment_type_id]) if result[:payment_method][:payment_type_id]
      payment_method_description = payment_method.andand.description
    elsif params[:id]
      response_id = params[:id]
    else
      response_id = nil
    end
    is_already_on_guest_card = (result && result[:is_already_on_guest_card]) ? result[:is_already_on_guest_card] : false
    data = {
              id: response_id,
              payment_type: payment_method_description,
              credit_card_type: credit_card_type,
              is_already_on_guest_card: is_already_on_guest_card
            }
    if reservation
      data = data.merge!(
            {
              bill_balance:  bill_balance,
              reservation_balance: reservation.current_balance,
              fees_information: reservation.bill_payment_method(1).andand.fees_information(hotel)
            })
    end
    if errors.empty?
      render json: {
                     status: SUCCESS,
                     data: data,
                     errors: [] }
    else
      render json: { status: FAILURE, data: nil, errors: errors }
    end
  end

  def link_payment
    reservation = Reservation.find(params[:reservation_id])
    payment_method = PaymentMethod.find(params[:user_payment_type_id])

    attributes = {
      payment_type: payment_method.payment_type.value,
      credit_card_type: payment_method.credit_card_type.to_s,
      card_name: payment_method.card_name,
      card_expiry: payment_method.card_expiry,
      mli_token: payment_method.mli_token,
      bill_number: 1
    }

    result = PaymentMethod.create_on_reservation!(reservation, attributes)
    errors = result[:errors]

    if errors.empty?
      render json: { status: SUCCESS, data: { id: params[:user_payment_type_id] }, errors: [] }
    else
      render json: { status: FAILURE, data: [], errors: errors }
    end
  end

  def reservation_room_upsell_options
    options = {}
    reservation = Reservation.find(params[:reservation_id])
    options[:room_type] = reservation.current_daily_instance.room_type if reservation.current_daily_instance
    options[:oo_service_status_id] = Ref::ServiceStatus[:OUT_OF_SERVICE].id
    if options[:room_type]
      upsell_options = ViewMappings::RoomTypesMapping.upsell_options(reservation, options)  
      active_business_date = current_hotel.active_business_date
      header_details = ViewMappings::StayCardMapping.get_reservation_header(reservation, active_business_date)
    else
      upsell_options = []
      header_details = {}
    end
    respond_to do |format|
      format.html { render partial:  'staff/room_upgrades/upgrades', locals: { upsell_data: upsell_options, header_details: header_details } }
      format.json { render json: { status: SUCCESS, data: { upsell_data: upsell_options, header_details: header_details }, errors: [] } }
    end
  end

  # print keys for reservation
  def print_key
    reservation = Reservation.find(params[:reservation_id])
    email = params[:email]
    status, data, errors = SUCCESS, {}, []

    # Save QR Code after deleting previous
    unless params[:key].present?
      status, data, errors = FAILURE, [], 'Invalid number of keys'
    end

    begin
      new_key = reservation.create_reservation_key(params[:is_additional], params[:key], params[:uid])
    rescue ActiveRecord::RecordInvalid => ex
      status, data = FAILURE, []
      errors << ex.message
    end

    options = {
      # As per the CICO-11444, UI sending only :is_additional as boolean value always.
      is_additional: params[:is_additional],
      uid: params[:uid],
      encoder_id: params[:key_encoder_id] && KeyEncoder.find(params[:key_encoder_id]).encoder_id,
      is_kiosk: params[:is_kiosk] || false
    }

    key_api = KeyApi.new(reservation.hotel_id, true)
    result = key_api.create_key(reservation, new_key, email, request.host_with_port, options)

    if result[:status]
      status, data, errors = SUCCESS, result[:data], []
    else
      status, data, errors = FAILURE, [], result[:errors]
    end

    render json: { status: status, data: data, errors: errors }
  end

  def qr_code_image
    reservation_key = ReservationKey.find(params[:key_id])
    send_data reservation_key.qr_data, type: 'image/png', disposition: 'inline'
  end

  # Modify Reservation
  def modify_reservation
    errors, data = [], {}
    not_had_ready_room = true
    begin
      if !params.key?('reservation_id')
        errors = ['Parameter missing']
      else
        reservation = Reservation.find(params[:reservation_id])
        is_upsell_available =  reservation.current_daily_instance.room_type.upsell_available?(reservation)
        previous_room =  reservation.current_daily_instance.room
        if previous_room.present?
          if !previous_room.is_occupied && previous_room.is_ready?
            not_had_ready_room = false
          end
        end

        # Assign room from KIOSK
        if reservation && params[:is_kiosk]
          pms_response = reservation.assign_room_from_room_type
          errors = [I18n.t(:do_not_move_flag_set)] unless pms_response[:status]
        elsif reservation && params.key?('room_number')
          room = reservation.hotel.rooms.where(room_no: params[:room_number]).first

          if room
            room_type = room.room_type
            logger.debug 'update room number for reservation'
            upcoming_reservation_daily_instances = reservation.daily_instances.upcoming_daily_instances(reservation.hotel.active_business_date)
            preassigned_reservation = room.preassigned_reservation

            if upcoming_reservation_daily_instances.count > 0
              pms_error = false

              # check whether an external PMS is configured
              if reservation.hotel.is_third_party_pms_configured?

                # If room is preassigned, release room from other reservation prior to assigning
                pms_error = !preassigned_reservation.release_room_with_external_pms[:status] if preassigned_reservation

                # Assign room to this reservation

                pms_response = reservation.assign_room_with_external_pms(room.room_no)
                pms_error = !pms_response[:status] if !pms_error

              end

              if pms_error
                errors = [I18n.t(:do_not_move_flag_set)]
              else
                # Update all upcoming daily instance's rooms to new room number
                # Since certain cases 3rdparty PMS not assign requested room number, return the random room number
                # Update the pms response room number with SNT CICO - 5987

                is_room_auto_assigned = reservation.hotel.is_third_party_pms_configured? ? pms_response[:room_no] != params[:room_number].to_s : false
                room = reservation.hotel.rooms.find_by_room_no(pms_response[:room_no]) if reservation.hotel.is_third_party_pms_configured? &&  pms_response[:room_no]
                data = data.merge({is_room_auto_assigned: is_room_auto_assigned, room: pms_response[:room_no]}) if reservation.hotel.is_third_party_pms_configured?

                # When upgrading both room and room type should be updated in database
                upcoming_reservation_daily_instances.each do |daily_instance|
                  daily_instance.update_attributes(room_id: room.id, room_type_id: room_type.id)
                end

                is_upsell_available = reservation.current_daily_instance.room_type.upsell_available?(reservation)

                current_room =  reservation.current_daily_instance.room
                is_current_room_ready_and_vacant = (!current_room.is_occupied && current_room.is_ready?)
                if (reservation.arrival_date == reservation.hotel.active_business_date) && not_had_ready_room && is_current_room_ready_and_vacant && !params[:is_kiosk]
                  begin
                    if reservation.primary_guest.email.present? && reservation.hotel.settings.checkin_alert_is_on && reservation.hotel.settings.checkin_alert_on_room_ready
                      create_checkin_room_ready_notification(reservation)
                    end
                  rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
                    logger.debug "*********** error in creating notification for checkin reservation on room assignment : #{reservation.confirm_no}"
                    logger.debug "#{ex.message}"
                  end
                end
                # Set all daily instance's rooms to nil on preassigned reservation, if one exists
                preassigned_reservation.daily_instances.update_all(room_id: nil) if preassigned_reservation
              end
            else
              errors = ['Sorry you cannot update room number']
            end
          else
            errors = ['Room number does not exist']
          end
          data = data.merge({is_upsell_available: is_upsell_available})
        else
          logger.debug 'NO ACTIONS in modify reservation'
          errors = ['Parameter missing']
        end
      end
      if errors.count > 0
        response = { status: FAILURE, errors: errors }
      else
        response = { status: SUCCESS, errors: [], data: data}
      end
    rescue ActiveRecord::RecordNotFound => e
      errors = [e.message]
    end
    render json: response
  end

  def checkin
    errors = []
    reservation = Reservation.find(params[:reservation_id])
    reservation.primary_guest.update_attributes(is_opted_promotion_email: params[:is_promotions_and_email_set]) if reservation.primary_guest
    Time.zone = reservation.hotel.tz_info
    third_party_pms_configured = current_hotel.is_third_party_pms_configured?

    signature_image = nil
    if reservation.hotel.settings.require_signature_at === Setting.signature_display[:checkin] && !params[:is_kiosk]
      # Parse the JSON data, create image and return as blob data
      signature_image = reservation.create_image(params[:signature])
    end
    signature_image = Base64.decode64(params[:signature_image]) if params[:is_kiosk] && params[:signature_image].present?

    wakeup = reservation.wakeups.first
    payment_type_attrs = ViewMappings::PaymentTypeMapping.map_payment_type(params)
    add_to_guest_card = params[:add_to_guest_card] == 'true'
    result = PaymentMethod.create_on_guest!(reservation.primary_guest, reservation.hotel, payment_type_attrs, true) if reservation.primary_guest && add_to_guest_card
    logger.debug "Cannot add payment while checking in #{result[:errors]}" if result && !result[:errors].empty?
    
    if params[:no_post] && !params[:no_post].nil? && !params[:no_post].to_s.empty?
      no_post = params[:no_post]
    else
      no_post = nil
    end
    reservation.update_attribute(:no_post, no_post)

    result = reservation.checkin(signature_image, :ROVER, no_post, payment_type_attrs)

    if result[:success]
      # Removed reservation.sync_booking_with_external_pms as per CICO-10462

      if wakeup.present?
        room_no = reservation.current_daily_instance.andand.room.andand.room_no

        wakeup.update_attributes(room_no: room_no) if wakeup.room_no != room_no

        if third_party_pms_configured
          data_hash = { room_no: room_no, hotel_id: wakeup.hotel_id, start_date: wakeup.start_date, end_date: wakeup.end_date }

          data_hash[:time] = wakeup.time.strftime('%H:%M:%S') + Time.zone.now.formatted_offset
          data_hash[:external_id] = reservation.external_id
          reservation.sync_wakeups_with_external_pms(data_hash, 'ADD')
        end
      end

      room_key_setup = reservation.hotel.settings.room_key_delivery_for_rover_check_in

      if room_key_setup == 'email'
        begin
          new_key = reservation.reservation_keys.empty? ? reservation.create_reservation_key(false, 1) : reservation.reservation_keys.first
          ReservationMailer.staff_send_reservation_key(new_key.id, ReservationMailer.default_url_options[:host], reservation,
                                                     reservation.primary_guest.email).deliver! if reservation.primary_guest.andand.email.present?
        rescue ActiveRecord::RecordNotFound => ex
          errors << ex.message
        end
      end
    else
      if result[:message]
        if result[:message].include?('resource busy and acquire with NOWAIT specified')
          errors << 'Reservation currently accessed in PMS, cannot update!'
        elsif result[:message] =~ /Authorize Failed/
          errors << I18n.t(:credit_card_authorization_failed)
        elsif result[:message].include?('COULD_NOT_CHECKIN_RESERVATION_IN_CHECKIN_OFFSET')
          errors << 'Checkin Time is not within Checkin Grace Period Time'
        else
          errors << 'Unable to check-in'
        end
      end
      if params[:is_kiosk]
        recipients =  reservation.hotel.web_checkin_staff_alert_emails.pluck(:email)  
        reservation.send_checkin_failure_staff_alert(recipients, result[:message].to_s)
       end

      logger.error "Could not check-in reservation: #{reservation.id} with errors - #{result[:message]}"
    end

    if errors.empty?
      render json: { status: SUCCESS, data: { check_in_status: 'Success' }, errors: [] }
    else
      render json: { status: FAILURE, data: {}, errors: errors }
    end
  end

  def bill_card
    errors = []
    logger.debug '*' * 30 + 'bill_card' + '*' * 30
    if params.key?('reservation_id')
      begin
        reservation = Reservation.find(params[:reservation_id])

        if reservation
          # sync invoice with external pms and insert into local tables
          reservation.sync_bills_with_external_pms  if current_hotel.is_third_party_pms_configured?

          # call bill_card_mapping to return transaction details from local tables
          bill_card = ViewMappings::BillCardMapping.map_bill_card(reservation, current_hotel)
        end
      rescue ActiveRecord::RecordNotFound => e
        errors = [e.message]
      end
    else
      errors = ['Parameter Missing']
    end

    respond_to do |format|
      format.html { render :layout => false, :locals => {:data => bill_card, :errors => errors} }
      format.json { render json: bill_card }
    end

  end

  def get_key_setup_popup
    reservation = Reservation.find(params[:id])
    room_key_setup = reservation.hotel.settings.room_key_delivery_for_rover_check_in
    partial_file = 'modals/keys/keyEmailModal'
    if room_key_setup != 'email'
      partial_file = 'modals/keys/key_encode_modal'
    else
      new_key = reservation.reservation_keys.empty? ? reservation.create_reservation_key(false, 1) : reservation.reservation_keys.first
      ReservationMailer.staff_send_reservation_key(new_key.id, ReservationMailer.default_url_options[:host], reservation,
                                                   reservation.primary_guest.email).deliver! if reservation.primary_guest.andand.email.present?
    end
    data = ViewMappings::StayCardMapping.map_key_setup(reservation)
    respond_to do |format|
      format.html { render partial: partial_file, locals: { status: SUCCESS, data: data, errors: [] } }
      format.json { render json: { status: SUCCESS, data: data, errors: [] } }
    end
  rescue ActiveRecord::RecordNotFound => ex
    render json: { status: FAILURE, errors: ["Email template is not configured"] }
  end

  # upsell room
  def upgrade_room
    errors = []
    # check to see if mandatory parameters exist
    if !params[:reservation_id].present? || !params[:room_no].present?
      logger.debug "Mandatory parameters are missing for reservation: #{params[:reservation_id]}"
      errors << I18n.t('reservation.mandatory_parameters_missing')
    elsif params[:upsell_amount_id].present? || params[:upsell_amount].present?
      if !params[:upsell_amount_id].present? && params[:upsell_amount] !~ /\A\d*\.?\d{2}?\Z/
        errors << I18n.t('reservation.upsell_charge_not_amount')
      end
    end
    if !errors.present?
      reservation = Reservation.find(params[:reservation_id])
      upsell_amount = 0
      if params[:upsell_amount_id].present?
        upsell_amount = current_hotel.upsell_amounts.find(params[:upsell_amount_id]).amount.to_f
      elsif params[:upsell_amount].present?
        upsell_amount = params[:upsell_amount].to_f
      end
      # call upgrade room method in reservation
      result = reservation.upgrade_room(upsell_amount, params[:room_no], :ROVER)
      is_upsell_available = reservation.current_daily_instance.room_type.upsell_available?(reservation)
      errors = result[:errors] unless result[:status]
    end

    render json: { status: errors.empty? ? SUCCESS : FAILURE, data: {is_upsell_available: is_upsell_available}, errors: errors }
  end

  # Checkout
  def checkout
    data = ''
    status = FAILURE
    errors = []
    result = {}

    begin
      reservation = Reservation.find(params[:reservation_id])
    rescue ActiveRecord::RecordNotFound => ex
      logger.error "Could not find reservation: #{params[:reservation_id]}"
      errors << ex.message
    end

    if reservation.present?
      hotel = reservation.hotel
      if reservation.status === :CHECKEDIN &&  hotel.active_business_date <= reservation.dep_date
        recipients = reservation.hotel.web_checkout_staff_alert_emails.checkout_alerts.pluck(:email)
        is_alert_staff = (reservation.hotel.settings.is_send_checkout_staff_alert.to_s == 'true' && !recipients.empty?)

        if current_hotel.is_third_party_pms_configured?
          result = reservation.checkout_with_external_pms
        else
          result = { status: true }
        end

        if result[:status]
          Action.record!(reservation, :CHECKEDOUT, :ROVER, hotel.id)

          data = "#{reservation.primary_guest.full_name.upcase} HAS CHECKED OUT"

          if reservation.hotel.settings.require_signature_at === Setting.signature_display[:checkout]
            signature_image = reservation.create_image(params[:signature])
            reservation.signature.destroy if reservation.signature
            reservation.build_signature(base64_data: signature_image)
            reservation.departure_time = Time.now.utc
            reservation.save!
          end

          if reservation.update_checkout_details
            status = SUCCESS
            unless reservation.hotel.is_third_party_pms_configured?
              begin
                reservation.bills.each do |bill|
                  ReservationMailer.send_guest_bill(reservation,bill).deliver! if reservation.primary_guest.email.present?
                  logger.debug "*********** error in sending bill to reservation : #{reservation.confirm_no} - no email address present " unless reservation.primary_guest.email.present?
                end
              rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
                logger.debug "*********** error in sending bill to reservation : #{reservation.confirm_no}"
                logger.debug "#{ex.message}"
              end
            end
          else
            logger.error "Could not update checkout for reservation: #{reservation.id} in StayNTouch"
            errors << 'Unable to update checkout details in StayNTouch'
          end
        else
          if is_alert_staff && params[:is_kiosk]
            recipients.each do |recipient|
              ReservationMailer.alert_staff_on_checkout_failure(reservation, recipient, result[:message]).deliver
            end
          end
          logger.error "Could not checkout reservation: #{reservation.id} in External PMS"

          if result[:message].include?('resource busy and acquire with NOWAIT specified')
            errors << 'Reservation currently accessed in PMS, cannot update!'
          elsif result[:message].include?('authorization failed')
             errors << "Credit Card authorization was declined, please try another card."
          else
            errors << "External PMS Checkout error Confirm Number - #{reservation.confirm_no}- " + result[:message] if reservation
          end
        end
      else
        logger.error "Invalid Reservation status/departure date for checkout in reservation: #{reservation.id}"
        errors << 'Invalid Reservation status/departure date'
        data = "#{reservation.primary_guest.full_name.upcase} WAS NOT CHECKED OUT"
      end
    end
    render json: { status: status, data: data, errors: errors }
  end

  def post_payment
    data = {}
    status = FAILURE
    errors = []
    bill_number = params[:bill_number].present? ? params[:bill_number] : 1
    amount = params[:amount]
    begin
      reservation =  Reservation.find(params[:reservation_id])
    rescue ActiveRecord::RecordNotFound => ex
      logger.error "Could not find reservation: #{params[:reservation_id]}"
      errors << ex.message
    end
    if reservation.present?
      if bill_number.present? && amount.present?
        card_data = reservation.bill_payment_method(bill_number) unless params[:guest_payment_id]
        card_data = reservation.primary_guest.payment_methods.where(id: params[:guest_payment_id]).first if params[:guest_payment_id]
        card_data = reservation.payment_methods.find(params[:guest_payment_id]) if params[:guest_payment_id] && !card_data.present?

        result = reservation.make_reservation_payment(card_data, bill_number, amount, params[:fees_amount], params[:fees_charge_code_id])
        if result[:status]
          status = SUCCESS
          data = 'Payment Completed'
        else
          data, errors = {}, ['Unable to make payment - ' + result[:message]]
        end
      else
        errors << 'Invalid Parameters'
      end
    end
    render json: { status: status, data: data, errors: errors }
  end

  def get_pay_bill_details
    @data = {}
    status = FAILURE
    errors = []

    begin
      reservation =  Reservation.find(params[:id])
    rescue ActiveRecord::RecordNotFound => ex
      logger.error "Could not find reservation: #{params[:reservation_id]}"
      errors << ex.message
    end

    if reservation.present?
      # Use bill #1, unless a bill number is sent
      bill_number = params[:bill_number] || 1

      payment_method = reservation.bill_payment_method(bill_number)
      @data['card_number'] = payment_method.andand.mli_token_display || ''
      @data['cardcode'] = payment_method.andand.credit_card_type.to_s
      @data['amount'] = reservation.current_balance || '0.00'
      @data['currency_code'] = reservation.hotel.default_currency.to_s
      status = SUCCESS
    end

    respond_to do |format|
      format.html { render partial: 'modals/billCardPayment', locals: { data: @data } } ## TODO replace with actual partial file from UI story
      format.json { render json: { status: status, data: @data, errors: errors } }
    end
  end

  def get_key_on_tablet
    data = {}
    status = FAILURE
    errors = []
    reservation = Reservation.find(params[:id])
    unless  reservation.reservation_keys.present?
      reservation.create_reservation_key('false', '1')
    end
    key_data = reservation.reservation_keys.first
    data = {
      reservation_status: ViewMappings::StayCardMapping.map_view_status(reservation, current_hotel.active_business_date),
      qr_code_image: key_data.present? ? "data:image/jpeg;base64, #{Base64.encode64(key_data.qr_data)}" : '' ,
      room_number: reservation.current_daily_instance.room ? reservation.current_daily_instance.room.room_no : '' ,
      confirmation_number: reservation.confirm_no,
      email: reservation.primary_guest.email,
      is_late_checkout: reservation.is_opted_late_checkout.to_s,
      late_checkout_time: reservation.late_checkout_time ? reservation.late_checkout_time.strftime('%I:%M %p') : '',
      user_name: " #{reservation.andand.primary_guest.andand.first_name}  #{reservation.andand.primary_guest.andand.last_name}"
    }
    status = SUCCESS
    respond_to do |format|
      format.html { render partial: 'modals/keys/keyQrCodeModal', locals: { data: data } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def show_key_delivery
    data = {}
    status = FAILURE
    errors = []
    reservation = Reservation.find(params[:id])
    key_data = reservation.reservation_keys.first
    data[:room_number] = reservation.current_daily_instance.room ?  reservation.current_daily_instance.room.room_no : ''
    status = SUCCESS
    respond_to do |format|
      format.html { render partial: 'modals/selectKeyModal', locals: { data: data } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

   def deposit_and_balance
      bill_number = params[:bill_number] || 1 # default to bill #1 if not provided
      reservation = current_hotel.reservations.find(params[:id])
      data = ViewMappings::StayCardMapping.get_credit_cards(reservation, bill_number)
      if reservation.hotel.is_third_party_pms_configured?
        reservation_api = ReservationApi.new(current_hotel.id)
        booking_attributes = reservation_api.get_booking(reservation.confirm_no)
        balance_and_deposit = ViewMappings::StayCardMapping.get_balance_and_deposit(booking_attributes[:data])
      else
        balance_and_deposit = ViewMappings::StayCardMapping.standalone_balance_and_deposit(reservation)
      end

      data = data.merge(balance_and_deposit) if balance_and_deposit

      credit_card_payment_types = PaymentType.activated_credit_card(current_hotel) + current_hotel.credit_card_types

      data = data.merge({
        :credit_card_types => credit_card_payment_types.map { |credit_card_type|
          hotel_credit_card_type = credit_card_type.is_a?(PaymentType) ?
                HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => credit_card_type.id).first :
                HotelsCreditCardType.where(:hotel_id => current_hotel.id, :ref_credit_card_type_id => credit_card_type.id).first

          {
              :id => credit_card_type.id,
              :card_name => credit_card_type.description,
              :cardcode  => credit_card_type.value,
              :is_display_reference => hotel_credit_card_type.andand.is_display_reference
          }
        }
      })

      respond_to do |format|
        format.html { render partial: 'modals/reservations/depositAndBalance', locals: { data: data }}
        format.json { render json: { status: SUCCESS, data: data, errors: [] }
      }
    end
   end

  private

  def create_checkin_room_ready_notification(reservation)
    notification = NotificationDetail.find_by_notification_id_and_notification_type_and_notification_section(reservation.id, Setting.notification_type[:reservation], Setting.notification_section_text[:check_in])
    NotificationDetail.create_reservation_notification(reservation, Setting.notification_section_text[:check_in], nil) unless notification
    reservation.send_checkin_email
  end

end
