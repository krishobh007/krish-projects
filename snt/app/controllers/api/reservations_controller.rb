# reservations_controller.rb
class Api::ReservationsController < ApplicationController
  before_filter :check_session
  before_filter :retrieve, only: [:queue, :email_confirmation, :show, :update, :policies, :cancel]
  before_filter :get_reservation, only: [:unassign_room]
  after_filter :load_business_date_info
  before_filter :check_business_date

  # Returns the details of reservation
  def show
    # Removed sync with external PMS
    # Same is called in reservation_details API
    # CICO-10462

    business_date = current_hotel.active_business_date

    stay_card_hash = { timeline: @reservation.timeline(business_date).to_s }

    primary_guest = @reservation.primary_guest

    if primary_guest
      # Find all other reservations for this user
      reservations = primary_guest.reservations.where(hotel_id: current_hotel.id).order(:confirm_no)
      guest_card_hash = ViewMappings::StayCardMapping.map_guest_card_contact_info(@reservation) if @reservation.guest_details

      reservation_id_hash = {
        current_reservations_arr: ViewMappings::StayCardMapping.build_reservation_ids(reservations.current_reservations(business_date),
                                                                                      current_hotel),
        history_reservations_arr: ViewMappings::StayCardMapping.build_reservation_ids(reservations.history_reservations(business_date),
                                                                                      current_hotel),
        upcoming_reservations_arr: ViewMappings::StayCardMapping.build_reservation_ids(reservations.upcoming_reservations(business_date),
                                                                                       current_hotel)
      }
    else
      guest_card_hash = {}
      selected_reservation_arr = ViewMappings::StayCardMapping.build_reservation_ids([@reservation], current_hotel)

      if @reservation.current?(business_date)
        reservation_id_hash = { current_reservations_arr: selected_reservation_arr, history_reservations_arr: [], upcoming_reservations_arr: [] }
      elsif @reservation.upcoming?(business_date)
        reservation_id_hash = { current_reservations_arr: [], history_reservations_arr: [], upcoming_reservations_arr: selected_reservation_arr }
      else
        reservation_id_hash = { current_reservations_arr: [], history_reservations_arr: selected_reservation_arr, upcoming_reservations_arr: [] }
      end
    end

    future_reservation_counts = {
      guest: primary_guest.andand.future_reservation_count(business_date, @reservation),
      company: @reservation.company.andand.future_reservation_count(business_date, @reservation),
      travel_agent: @reservation.travel_agent.andand.future_reservation_count(business_date, @reservation)
    }

    external_references_hash = @reservation.external_references.map do |external_reference|
      {
        value: external_reference.value,
        description: external_reference.description,
        type: external_reference.reference_type.to_s
      }
    end

    render json: {
      data: {
        guest_details: guest_card_hash,
        reservation_details: stay_card_hash,
        reservation_list: reservation_id_hash,
        company_id: @reservation.company_id,
        travel_agent_id: @reservation.travel_agent_id,
        future_reservation_counts: future_reservation_counts,
        external_references: external_references_hash
      },
      status: SUCCESS,
      errors: []
    }
  end

  def create
    begin
      errors = []
      confirmation_emails = params[:confirmation_emails]
      tax_details = params[:tax_details]
      @reservations_list = []
      if !cards_valid?
        errors << I18n.t('reservation_cards.one_card_required')
      elsif !emails_valid?(confirmation_emails)
        errors << I18n.t('mailer.reservation_mailer.email_validation')
      else
        Reservation.transaction do
          # Create multiple reservations, if room ids are present in the request (Hourly reservations).
          if params[:room_id] && !params[:room_id].empty?
            params[:room_id].each do |room_id|
              room = Room.find(room_id)
              departure_datetime = getDatetime(params[:departure_date], params[:departure_time], current_hotel.tz_info).utc
              arrival_datetime = getDatetime(params[:arrival_date], params[:arrival_time], current_hotel.tz_info).utc
              # Check whether the requested room is assigned to any other reservations in the time span
              existing_reservation_count = room.reservation_daily_instances.joins(:reservation).
                                           where("reservations.arrival_time <= ? and reservations.departure_time >= ?",
                                           departure_datetime, arrival_datetime).where("reservations.status_id NOT IN (?,?)",
                                           Ref::ReservationStatus[:NOSHOW].id, Ref::ReservationStatus[:CANCELED].id).uniq.count
              # If exsting room counts goes greater than zero, break the loop
              if existing_reservation_count > 0
                errors << I18n.t('room_not_available')
                break
              else
                @reservation = create_reservation
                (@reservation.arrival_date..@reservation.dep_date).each { |day|
                  @reservation.daily_instances.create!(daily_instance_attributes(day, room_id))
                  # Update Inventory count - Based on story CICO-8604
                  if day != @reservation.dep_date || @reservation.dep_date == @reservation.arrival_date
                    stay_date = stay_attributes(day, room_id)
                    if @reservation.is_hourly
                      HourlyInventoryDetail.map_inventories(@reservation)
                    else
                      inventory_detail = InventoryDetail.record!(stay_date[:rate_id], stay_date[:room_type_id], current_hotel.id, day, true) if stay_date.present?
                    end
                  end
                }
                @reservation.daily_instances.update_all(room_id: room_id)
              end

              @reservations_list << @reservation
            end
          # If no room_id present in the request, trigger normal reservation creation.
          else
            @reservation = create_reservation
            (@reservation.arrival_date..@reservation.dep_date).each { |day|
              @reservation.daily_instances.create!(daily_instance_attributes(day, nil))
              # Update Inventory count - Based on story CICO-8604
              if day != @reservation.dep_date || @reservation.dep_date == @reservation.arrival_date
                stay_date = stay_attributes(day, nil)
                if @reservation.is_hourly
                  HourlyInventoryDetail.map_inventories(@reservation)
                else
                  inventory_detail = InventoryDetail.record!(stay_date[:rate_id], stay_date[:room_type_id], current_hotel.id, day, true) if stay_date.present?
                end
              end
            }
            @reservations_list << @reservation
          end
        end
      end

      if errors.present?
        render(json: errors, status: :unprocessable_entity) if errors.present?
      else
        send_confirmation_emails(confirmation_emails, tax_details)
      end
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
    end
  end

  def create_reservation
    @reservation = Reservation.create!(reservation_attributes)
    update_guest! if params[:guest_detail_id]
    @reservation.reservations_addons.create!(addons_attributes) if params[:addons]
    PaymentMethod.create_on_reservation!(@reservation, payment_type_attributes, false) if params[:payment_type].present?
    @reservation
  end

  def update
    errors = []

    confirmation_emails = params[:confirmation_emails]
    tax_details = params[:tax_details]
    
   # Check whether there is any pre-reservation in the time slot - If YES throw error. 
    if params[:room_id] && !params[:room_id].empty? && @reservation.is_hourly
      room_id = params[:room_id].first
      room = Room.find(room_id)
      departure_datetime = getDatetime(params[:departure_date], params[:departure_time], current_hotel.tz_info).utc
      arrival_datetime = getDatetime(params[:arrival_date], params[:arrival_time], current_hotel.tz_info).utc
      # Check whether the requested room is locked for any reservations.
      existing_pre_reservation_count = room.pre_reservations
                                       .where('from_time <= ? and to_time >= ?', departure_datetime, arrival_datetime).uniq.count
      # Check whether the requested room is assigned to any other reservations in the time span
      existing_reservation_count = room.reservation_daily_instances.joins(:reservation).
                                   where("reservations.arrival_time <= ? and reservations.departure_time >= ?",
                                   departure_datetime, arrival_datetime)
                                   .where("reservations.id != ?", @reservation.id)
                                   .where("reservations.status_id NOT IN (?,?)",
                                   Ref::ReservationStatus[:NOSHOW].id, Ref::ReservationStatus[:CANCELED].id).uniq.count
      
      # If exsting pre-reservation counts goes greater than zero, populate errors array
      if existing_pre_reservation_count > 0
        errors << I18n.t('locked_room_not_available')
      end

      # If exsting room counts goes greater than zero, break the loop
      if existing_reservation_count > 0
        errors << I18n.t('room_not_available')
      end
    end

    # CICO-10558 - Removed previous check
    if !emails_valid?(confirmation_emails)
      error << I18n.t('mailer.reservation_mailer.email_validation')
    elsif errors.empty?
      Reservation.transaction do
        record_inventory(@reservation)
        if @reservation.is_hourly
          # Hourly inventories decrement current sold count
          HourlyInventoryDetail.map_inventories(@reservation, true)
        end

        # To calculrate old rate and new rate amount diff.
        old_rate_amount = @reservation.current_daily_instance.rate_amount.to_f

        # CICO-10195 To move the room for in-house reservation
        old_room = @reservation.current_daily_instance.room

        @reservation.update_attributes!(reservation_update_attributes)
        @reservation.daily_instances.outlying.destroy_all

        (@reservation.arrival_date..@reservation.dep_date).each do |day|
          daily_instance = @reservation.daily_instances.where(reservation_date: day).first

          # Build a new daily instance if one does not exist for this day
          daily_instance = @reservation.daily_instances.build unless daily_instance

          if params[:room_id] && !params[:room_id].empty?
            daily_instance.attributes = daily_instance_attributes(day, params[:room_id].first)
            daily_instance.room = Room.find(params[:room_id].first)
          else
            daily_instance.attributes = daily_instance_attributes(day, nil)
             # If the room type has changed on the reserved reservation, then remove the room
            daily_instance.room = nil if daily_instance.room_type_id_changed? && @reservation.status === :RESERVED
          end
          daily_instance.save!
        end

        # CICO- 10195, Room move for In house reservations
        # CICO -12503, We need to post the cabin charge, when the inhouse reservation
        # extended.
        room_move_inhouse_reservation(@reservation, old_room, old_rate_amount) if @reservation.is_hourly
      end
      if params[:addons]
        @reservation.reservations_addons.destroy_all
        @reservation.reservations_addons.create!(addons_attributes)
      end

      if params[:payment_type].present?
        if params[:reservation_ids].nil?
          # @reservation.payment_methods.destroy_all
          @reservation.payment_methods.create_on_reservation!(@reservation, payment_type_attributes, params[:add_to_guest_card])
        else
          if params[:reservation_ids].is_a?(Array)
            params[:reservation_ids].each do |r_id|
              reservation = Reservation.find(r_id)
              reservation.payment_methods.create_on_reservation!(reservation, payment_type_attributes, params[:add_to_guest_card])
            end
          end
        end
      end
    end
    if errors.present?
      render(json: errors, status: :unprocessable_entity) if errors.present?
    else
      send_confirmation_emails(confirmation_emails, tax_details)
    end
  rescue ActiveRecord::RecordInvalid => e
    render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end

  def record_inventory(reservation)
    reservation.daily_instances.each do |instance|
      if params[:room_id] && !params[:room_id].empty?
        stay_date = stay_attributes(instance.reservation_date, params[:room_id].first)
      else
        stay_date = stay_attributes(instance.reservation_date, nil)
      end
      if stay_date.present?
        if instance.room_type_id != stay_date[:room_type_id] || instance.rate_id != stay_date[:rate_id]
          if instance.reservation_date != reservation.dep_date || reservation.dep_date == reservation.arrival_date
            InventoryDetail.record!(instance.rate_id, instance.room_type_id, current_hotel.id, instance.reservation_date, false)
            InventoryDetail.record!(stay_date[:rate_id],stay_date[:room_type_id],current_hotel.id,stay_date[:date], true)
          end
        end
      else
        if instance.reservation_date != reservation.dep_date || reservation.dep_date == reservation.arrival_date
          InventoryDetail.record!(instance.rate_id, instance.room_type_id, current_hotel.id, instance.reservation_date, false)
        end
      end
    end
    current_dates = []
    (reservation.arrival_date..reservation.dep_date).each do |day|
      if day != reservation.dep_date || reservation.dep_date == reservation.arrival_date
        current_dates << day.to_s
      end
    end
    stays = []
    stays = params[:stay_dates].flatten(1) if params[:stay_dates]
    stays.each do |stay|
      unless current_dates.include? stay[:date]
        if stay[:date] != reservation.dep_date.to_s || reservation.dep_date == reservation.arrival_date
          InventoryDetail.record!(stay[:rate_id],stay[:room_type_id],current_hotel.id,stay[:date].to_date, true)
        end
      end
    end if stays.present?
  end

  def queue
    # TODO This status check added as part of 'CICO-6662' which is a 1.3
    # Once merge into V1.9 removed all the status check from API's and send original status
    status = FAILURE
    error = []
    if current_hotel.staff_alert_emails.queue_reservation_alerts.present?
      if params[:status] == 'true'
        begin
          HotelMailer.send_staff_alerts_on_queue_reservation(current_hotel, @reservation).deliver!
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
           logger.debug "*********** error in notifying staff on queue reservation  : #{@reservation.confirm_no}"
           logger.debug "#{ex.message}"
        end
      end
      @reservation.is_queued = params[:status]
      if @reservation.is_queued == true
        @reservation.put_in_queue_updated_at = Time.now.utc
      end
      @reservation.save!
      status = SUCCESS
    else
      reservation_api = ReservationApi.new(current_hotel.id)
      response = reservation_api.queue_reservation(@reservation.external_id, params[:status])
      if response[:status]
        @data = response[:data]
        @reservation.is_queued = params[:status]
        if @reservation.is_queued == true
          @reservation.put_in_queue_updated_at = Time.now.utc
        end
        @reservation.save!
        status = SUCCESS
      else
        error =  I18n.t('reservation.external_pms.cannot_queue_reservation')
      end
    end
    render json: { status: status, data: {}, errors: error }
  rescue ActiveRecord::RecordInvalid => e
    render json: { status:  FAILURE, data: {}, errors: e.record.errors.full_messages }
  end

  def email_confirmation
    emails = params[:emails]
    tax_details = params[:tax_details]
    email_type = params[:type] || Setting.defaults[:email_confirmation_types][:confirmation]
    errors = []

    if !emails_valid?(emails)
      errors << I18n.t('mailer.reservation_mailer.email_validation')
    else
      begin
        if email_type == Setting.defaults[:email_confirmation_types][:confirmation]
          send_confirmation_emails(emails, tax_details)
        elsif email_type == Setting.defaults[:email_confirmation_types][:cancellation]
          send_cancellation_email
        end
      rescue Exception => ex
        logger.error "#{ex.message}\n #{ex.backtrace}"
        errors << I18n.t('mailer.reservation_mailer.email_send_failed')
      end
    end

    render(json: errors, status: :unprocessable_entity) if errors.present?
  end

  # Un-assign a room
  def unassign_room
    errors = []
    current_room =  @reservation.current_daily_instance.room
    hotel = @reservation.hotel
    if !hotel.is_third_party_pms_configured? && current_room.present? && (@reservation.due_in? || @reservation.upcoming?(hotel.active_business_date))
      @reservation.daily_instances.update_all(room_id: nil) ||
      render(json: @reservation.errors.full_messages, status: :unprocessable_entity)
    elsif hotel.is_third_party_pms_configured?
      errors << I18n.t(:allowed_for_standalone_hotels_only)
    elsif !current_room.present?
      errors << I18n.t(:room_not_found)
    elsif !(@reservation.due_in? || @reservation.upcoming?(hotel.active_business_date))
      errors << I18n.t(:allowed_for_duein_and_reserved_only)
    end
    render(json: errors, status: :unprocessable_entity) if errors.present?
  end

  def email_guest_bill
    errors = []
    reservation = Reservation.find(params[:reservation_id])
    bill = reservation.bills.find_by_bill_number(params[:bill_number])
    begin
      ReservationMailer.send_guest_bill(reservation, bill).deliver! if reservation.primary_guest.andand.email.present?
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      logger.error "#{e.message}"
      errors << e.message
    end
    render(json: errors, status: :unprocessable_entity) unless errors.empty?
  end

  def submit_payment
    hotel = current_hotel

    #Only deposit is handled now for multiple reservations
    #If multiple reservations
    reservations = hotel.reservations.where('id in (?)', params[:reservation_ids])
    #Find all reservations from params[:reservation_ids]
    #Else make just initialize an array of reservations with only one reservation found from params[:reservation_id]
    reservations = [hotel.reservations.find(params[:id])] if !params[:reservation_ids]

    is_multi_deposite = false
    if params[:reservation_ids] && params[:reservation_ids].is_a?(Array) && params[:reservation_ids].size > 1
      is_multi_deposite = true
    end
    #Loop through each
    #Submit payment for each reservation
    data, errors = [], []
    amount = params[:amount].to_f
    params[:initial_amount]     = amount
    credit_card_transaction = nil
    reservations.each_with_index do |reservation, idx|
      params[:amount] = amount
      params[:credit_card_transaction] = credit_card_transaction
      if reservation.deposit_amount <= amount && is_multi_deposite
        amount = amount - reservation.deposit_amount
        params[:amount] = reservation.deposit_amount
      end
      #Clear fees amounts and charge code for reservations other than the first one, total CC fees is posted in the first reservation
      params[:fees_amount], params[:fees_charge_code_id] = nil, nil if idx != 0
      result = reservation.submit_payment_to_bill(params)
      errors << result[:errors] if !result[:errors].empty?
      data << result[:data]
      credit_card_transaction = result[:credit_card_transaction]
    end
    if errors.empty?
      render json: data.first #API response only needs the first reservation at this point
    else
      render json: errors, status: 422
    end
  end

  def bills
    errors = []
    begin
      reservation = current_hotel.reservations.find(params[:id])
    rescue ActiveRecord::RecordNotFound => ex
      errors << 'Invalid Reservation ID'
    end
    unless errors.present?
      reservation.bills.create(bill_number: 1) unless reservation.bills.present?
      @bill_numbers =  reservation.bills.pluck(:bill_number).map { |i| i.to_s }
    end
    render(json: errors, status: :unprocessable_entity) unless errors.empty?
  end

  # Based on CICO-1403
  def cancel
    errors = []
    hotel = current_hotel
    is_cancel = false
    current_cc_payments = 0.0
    total_payments = 0.0
    current_charges = 0.0
    # Business Logic Check for reservation status
    cancel_flag = @reservation.status === :CHECKEDIN &&
                  @reservation.arrival_date == hotel.active_business_date &&
                  @reservation.current_balance.to_i == 0
    # Cancellation Allowed for Stand-Alone hotels Only
    if !hotel.is_third_party_pms_configured? && (@reservation.status === :RESERVED || cancel_flag)
      bill_one = @reservation.bills.present? ? @reservation.bills.first : Bill.create(bill_number: 1, reservation_id: @reservation.id)
      # Get the credit card type
     unless bill_one.andand.financial_transactions.empty?
       current_cc_payments =  NumberUtility.default_amount_format(bill_one.andand.financial_transactions.cc_credit.sum(:amount).to_f).to_f
       total_payments = NumberUtility.default_amount_format(bill_one.andand.financial_transactions.credit.sum(:amount).to_f).to_f
       current_charges = NumberUtility.default_amount_format(@reservation.bill_one.andand.financial_transactions.debit.sum(:amount).to_f).to_f
     end

     financial_transactions = bill_one.financial_transactions
     credit_card_type = @reservation.primary_payment_method.andand.credit_card_type

     current_rate = @reservation.daily_instances.first.andand.rate
     # Get the cancellation policy for the rate
     cancellation_policy = current_rate.cancellation_policy
     #Get all deposits for the reservation in bill 1
     # Get the charge code for the rate
     rate_charge_code = current_rate.charge_code
      if credit_card_type.present? && current_cc_payments <= 0
        charge_codes = hotel.charge_codes.payment
        charge_code = charge_codes.cc.find_by_associated_payment_id(credit_card_type.id)
        # Get the rate for reservation - Only first rate is considered as per CICO-1403

        # Get the penalty charge for the reservation
        penalty_charge = cancellation_policy.present? ? @reservation.cancellation_penalty(cancellation_policy.id, cancellation_policy.post_type) : 0
        if charge_code.present? && rate_charge_code.present?
          # Record financial transaction for payment method
          pay_transaction = financial_transactions.create!(amount: penalty_charge,
            date: hotel.active_business_date,
            currency_code_id: hotel.default_currency.andand.id,
            charge_code_id: charge_code.andand.id,
            time: current_hotel.current_time) unless params[:with_deposit_refund]
          if pay_transaction
            FinancialTransaction.record_action(pay_transaction, :CREATE_TRANSACTION, :WEB, current_hotel.id)
            pay_transaction.set_cashier_period
            pay_transaction.record_details({payment_method: @reservation.primary_payment_method, comments: "Penalty payment on reservation cancellation."})
          end
          # Record financial transaction for penalty charge
          penalty_charge_code = cancellation_policy.andand.charge_code
          penalty_charge_code_id = penalty_charge_code ? penalty_charge_code.id : rate_charge_code.andand.id
          charge_transaction = financial_transactions.create!(amount: penalty_charge,
            date: hotel.active_business_date,
            currency_code_id: hotel.default_currency.andand.id,
            charge_code_id: penalty_charge_code_id,
            time: current_hotel.current_time) unless params[:with_deposit_refund]
          if charge_transaction
            FinancialTransaction.record_action(charge_transaction, :CREATE_TRANSACTION, :WEB, current_hotel.id)
            charge_transaction.set_cashier_period
            charge_transaction.record_details({comments: "Penalty charge on reservation cancellation."})
          end
          is_cancel = true
        else
          errors << "The charge code for selected payment type does not exist"
        end
      else
        is_cancel = true
      end
      if is_cancel
        # Allow cancellation with deposit refund only if the deposits are done by CC only
        is_cancel = (current_cc_payments == total_payments) if params[:with_deposit_refund] && (( current_cc_payments + total_payments ) > 0 )
        ActiveRecord::Base.transaction do
          begin
            if is_cancel && @reservation.cancel
              @reservation.cancel_reason = params[:reason]
              @reservation.save!
              @reservation.post_deposit_refund_transactions(params[:with_deposit_refund],rate_charge_code,charge_code,(total_payments-current_charges))
            elsif is_cancel == false
               errors << "Deposit refund can not be processed to this payment type. Manual processing required"
            else
              errors << I18n.t(:reservation_cancellation_error)
            end
          rescue Exception => ex
            errors << ex.message
            logger.error "*******   An exception occured while cancelling reservation : #{@reservation.confirm_no}  *******"
            logger.error "*******    #{ex.message}  *******"
          end
          raise ActiveRecord::Rollback unless errors.empty?
        end
      end
    elsif !(@reservation.status === :RESERVED || cancel_flag)
        errors << I18n.t(:cancellation_not_allowed)
    else
        errors << I18n.t(:allowed_for_standalone_hotels_only)
    end
    
    begin
      refund_amount = 0
      refund_amount = (total_payments-current_charges) if params[:with_deposit_refund]
      
      ReservationMailer.guest_send_cancellation_email(@reservation, refund_amount).andand.deliver if errors.empty?
    rescue => ex
      logger.error ex.message
      logger.error ex.backtrace
    end
    
    render(json: errors, status: :unprocessable_entity) if errors.present?
  end

  # Based on CICO-1403
  def policies
    hotel_business_date = current_hotel.active_business_date

    applied_policy = current_hotel.cancellation_policies.where(apply_to_all_bookings: true).first
    applied_policy = @reservation.daily_instances.first.andand.rate.andand.cancellation_policy if applied_policy.nil?

    # Notice Period - Within which a reservation cancellation not charged any penalty
    @current_payments = NumberUtility.default_amount_format(@reservation.bill_one.present? ?
            @reservation.bill_one.andand.financial_transactions.credit.andand.sum(:amount).to_f - @reservation.bill_one.andand.financial_transactions.fees.andand.sum(:amount).to_f
            : 0.0)

    if applied_policy.present?
      notice_end_date = @reservation.arrival_date - applied_policy.advance_days.to_i
      current_hotel_business_time = Time.now.in_time_zone(current_hotel.tz_info).utc.andand.strftime("%H%S%M%N")
      notice_end_time = applied_policy.advance_time.andand.strftime("%H%S%M%N")
      is_date_expired = (hotel_business_date > notice_end_date)
      is_same_date = (hotel_business_date == notice_end_date)
      is_time_expired = notice_end_time.present? ? (current_hotel_business_time > notice_end_time) : false
      # Business logic check - Add Cancellation Policy if hotel business date & time is outside notice period
      if is_date_expired || (is_same_date && is_time_expired)
        @penalty_charge = @reservation.cancellation_penalty(applied_policy.id, applied_policy.post_type)
        @applied_policy = applied_policy
      end
    end
  end

  def pay_bill
    errors = []
    reservation = current_hotel.reservations.find(params[:id])
    bill = reservation.bills.find_by_bill_number(params[:bill_number])
    payment_method = reservation.bill_payment_method(params[:bill_number])
    charge_code = ChargeCode.code(payment_method, current_hotel)
    reservation.post_transaction(bill, bill.current_balance, charge_code.andand.id)
    erorrs = bill.errors.full_messages
    render json: {
      status: errors.empty? ? SUCCESS : FAILURE,
      data: {
        bill_balance: bill.current_balance,
        reservation_balance: reservation.current_balance
      },
      errors: errors
    }
  end

  def advance_bill
    reservation = current_hotel.reservations.find(params[:id])
    reservation.post_advance_bill if !reservation.is_advance_bill
    bill_card = ViewMappings::BillCardMapping.map_bill_card(reservation, current_hotel)
    render json: { status: SUCCESS, data: bill_card, errors: []}
  end

  # Method to search reservation for posting charges
  def search_reservation
    reservations = Reservation.joins(:daily_instances).joins("LEFT OUTER JOIN rooms ON reservation_daily_instances.room_id = rooms.id")
      .joins("LEFT OUTER JOIN reservations_guest_details on reservations_guest_details.reservation_id = reservations.id")
      .joins("LEFT OUTER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id")
      .joins("LEFT OUTER JOIN addresses ON guest_details.id = addresses.associated_address_id AND addresses.associated_address_type = 'GuestDetail'")
      .joins("LEFT OUTER JOIN groups ON reservation_daily_instances.group_id = groups.id")
      .joins("LEFT OUTER JOIN additional_contacts as phone_contacts ON guest_details.id = phone_contacts.associated_address_id AND phone_contacts.associated_address_type = 'GuestDetail' AND phone_contacts.contact_type_id = #{Ref::ContactType[:PHONE].id} AND phone_contacts.label_id = #{Ref::ContactLabel[:HOME].id}" )
      .joins("LEFT OUTER JOIN additional_contacts as email_contacts ON guest_details.id = email_contacts.associated_address_id AND email_contacts.associated_address_type = 'GuestDetail' AND email_contacts.contact_type_id = #{Ref::ContactType[:EMAIL].id}")
      .joins("LEFT OUTER JOIN accounts as travel_agent_accounts ON reservations.travel_agent_id = travel_agent_accounts.id")
      .joins("LEFT OUTER JOIN accounts as company_accounts ON reservations.company_id = company_accounts.id")
      .search_by_hotel(params, nil, current_hotel, current_hotel.active_business_date, nil, nil, nil,true)
      .where("reservations.dep_date >= '#{current_hotel.active_business_date - 7.days}'")
      .select("reservations.id, reservations.hotel_id,reservations.arrival_time, reservations.departure_time, arrival_date, dep_date, confirm_no, reservations.status_id, is_queued, is_hourly, "\
             "groups.name as group_name, is_occupied, guest_details.id as guest_detail_id, reservation_date, is_opted_late_checkout, "\
             "late_checkout_time, reservations_guest_details.is_accompanying_guest, guest_details.first_name, guest_details.last_name, guest_details.is_vip, "\
             "addresses.city, addresses.state, phone_contacts.value as phone, email_contacts.value as email, addresses.country_id, rooms.room_no, rooms.is_occupied, rooms.id as room_id, rooms.hk_status_id, travel_agent_accounts.account_name as travel_agent_name, company_accounts.account_name as company_name")
    reservations = reservations.with_status(:RESERVED, :CHECKEDIN).order('guest_details.last_name', 'guest_details.first_name')
    result = ViewMappings::Search::SearchResultMapping.construct_results(reservations, current_hotel)

    render json: result
  end

  # Method to search reservation for KIOSK
  def kiosk_search
    @reservations  = current_hotel.reservations.kiosk_search(params,current_hotel)
  end

  # Method to prode reservation specific details to KIOSk
  def reservation_details
    @reservation = Reservation.find(params[:reservation_id])
    if @reservation.hotel.is_third_party_pms_configured?
      result = @reservation.sync_booking_with_external_pms
      @deposit_attributes_hash = result[:booking_attributes].present? ? ViewMappings::StayCardMapping.get_balance_and_deposit(result[:booking_attributes]) : {}
    else
      @deposit_attributes_hash = ViewMappings::StayCardMapping.standalone_balance_and_deposit(@reservation)
    end
  end

  def web_checkin_reservation_details
    @reservation = Reservation.find(params[:id])
  end

  def update_stay_details
    @reservation = Reservation.find(params[:id])
    guest_params = { mobile: params[:mobile] }

    @reservation.arrival_time = ActiveSupport::TimeZone[@reservation.hotel.tz_info].parse(params[:arrival_time]).utc if params[:arrival_time].present?

    arrival_time = @reservation.arrival_time.in_time_zone(@reservation.hotel.tz_info).strftime('%l:%M %p') if @reservation.arrival_time

    @reservation.comments = params[:comments]
    action = @reservation.hotel.settings.is_pre_checkin_only.to_s == "true" ? "Pre-Check In" : "Checkin" ## Added the string comparison since the values are stored as string when verified
    notes = []
    notes << "Guest #{action}: ETA = #{arrival_time}." if arrival_time
    notes << "Comment from guest: #{params[:comments]}" if params[:comments]
    notes << "Text Guest phone when room is ready: #{params[:mobile]}" if params[:mobile]
    note_description = notes.join("\n")
    if @reservation.hotel.is_third_party_pms_configured?
      @reservation.modify_notes_of_external_pms('ADD', [{ description: note_description }]) if note_description
    else
      reservation_note = @reservation.notes.new
      reservation_note.note_type =  :GENERAL
      reservation_note.is_guest_viewable =  false
      reservation_note.description =  note_description
      reservation_note.is_from_external_system =  false
      reservation_note.save
    end
    @reservation.primary_guest.update_guest_profile(guest_params, current_hotel)
    @reservation.save!
  end

  def pre_checkin
    @reservation = Reservation.find(params[:id])
    staff_emails = @reservation.hotel.web_checkin_staff_alert_emails
    response = { status: FAILURE, data: {}, errors: [] }
    web_checkedin_count = @reservation.hotel.actions.with_action_type(:CHECKEDIN).with_application(:WEB).where(actionable_type: 'Reservation').where(business_date: @reservation.hotel.active_business_date).count
    if @reservation.hotel.settings.max_webcheckin && web_checkedin_count >= @reservation.hotel.settings.max_webcheckin.to_i
      response[:errors] = ['No more web checkins allowed today']
      staff_emails.each do |recipient|
        begin
          @reservation.send_checkin_failure_staff_alert([recipient.email], response[:errors].to_s)
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
           logger.debug "*********** error in notifying staff on pre_checkin status for hotel : #{hotel.code}  reservation : #{@reservation.confirm_no}"
           logger.debug "#{ex.message}"
        end
      end
    else
      if @reservation.hotel.is_pre_checkin_only?
        response = @reservation.pre_checkin(:WEB)
        response[:status] = SUCCESS if response[:success] == true
        staff_emails.each do |recipient|
          begin
            if response[:success]
              @reservation.primary_guest.record_user_activity(:WEB, @reservation.hotel.id, Setting.user_activity[:login], Setting.user_activity[:success], I18n.t(:web_login_success), request.remote_ip)
              ReservationMailer.alert_staff_on_pre_checkin_success(@reservation,recipient.email).deliver! if (@reservation.hotel.settings.web_checkin_staff_alert_enabled == 'true')
            else
              @reservation.primary_guest.record_user_activity(:WEB, @reservation.hotel.id, Setting.user_activity[:login], Setting.user_activity[:failure], result[:errors].to_s, request.remote_ip)
              @reservation.send_checkin_failure_staff_alert([recipient.email], result[:errors].to_s)
            end
          rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
            logger.debug "*********** error in notifying staff on checkin reservation list for hotel : #{hotel.code}"
            logger.debug "#{ex.message}"
          end
        end
      else
        response[:errors] << 'Pre check in is not available for this hotel'
        staff_emails.each do |recipient|
          begin
            @reservation.send_checkin_failure_staff_alert([recipient.email], response[:errors].to_s)
          rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError  => ex
            logger.debug "*********** error in notifying staff on pre_checkin status : #{hotel.code}  reservation : #{@reservation.confirm_no}"
            logger.debug "#{ex.message}"
          end
        end
      end
    end
    render json: response
  end

  def hourly_confirmation_emails
    emails = params[:emails]
    reservation_ids = params[:reservation_ids]
    reservations = current_hotel.reservations.where('id in (?)', reservation_ids)
    emails.andand.each do |email|
      reservations.each do |reservation|
        reservation.tax_details = params[:tax_details]
        begin
          ReservationMailer.send_confirmation_number_mail(reservation, email).deliver!
        rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError, StandardError => e
          logger.error "Standalone PMS Confirmation Number Sending Failed - " \
                       "Email not sent confirmation number #{reservation.confirm_no} to #{email} : #{e.message} \n #{e.backtrace}"
        end
      end
    end
  end
  def deposit_policy
    reservation = current_hotel.reservations.find(params[:id])
    @deposit_policy = reservation.deposit_policy
    @payment_method = reservation.valid_primary_payment_method
    @deposit_amount = reservation.balance_deposit_amount
    @is_hourly = reservation.is_hourly
  end

  # API for KIOSK to get all the associated guests for a reservation
  def guests
    reservation = current_hotel.reservations.find(params[:reservation_id])
    @guests = reservation.accompanying_guests
  end

  # API for KIOSK to add new guest to reservation ( firstname , last_name )
  def add_guest
    reservation = current_hotel.reservations.find(params[:reservation_id])
    @guest_detail = reservation.guest_details.create(first_name: params[:first_name].capitalize , last_name: params[:last_name].capitalize, hotel_chain: current_hotel.hotel_chain)
    @guest_detail.reservations_guest_details.find_by_reservation_id(reservation.id).update_attributes(is_primary: false, is_accompanying_guest: true, is_added_from_kiosk: true)
    render(json: @guest_detail.errors, status: :unprocessable_entity) unless @guest_detail.errors.empty?
  end

   # API for KIOSK to detach a guest from reservation
  def remove_guest
    errors  = []
    reservation = current_hotel.reservations.find(params[:reservation_id])
    guest_detail = GuestDetail.find(params[:guest_id])
    errors = ["Unable to detach guest from reservation"] unless reservation.guest_details.delete(guest_detail)
    render(json: errors, status: :unprocessable_entity) unless errors.empty?
  end


  def early_checkin_details
    @data = {}
    reservation = current_hotel.reservations.find(params[:id])
    early_checkin_addons = reservation.addons.pluck(:id) & current_hotel.early_checkin_setups.pluck(:addon_id)
    current_early_checkin_offer = reservation.current_early_checkin_offer
    @data[:is_early_checkin_bundled] = reservation.is_early_checkin_bundled
    @data[:is_early_checkin_on] = current_hotel.settings.is_allow_early_checkin
    @data[:normal_arrival_time] = current_hotel.checkin_time.present? ? current_hotel.checkin_time.strftime("%l:%M %p").strip : ""
    @data[:is_room_upgrade_available] = reservation.current_daily_instance.room_type.upsell_available?(reservation)
    @data[:is_allow_free_early_checkin] =  @data[:is_early_checkin_bundled] && early_checkin_addons.empty?
    @data[:is_eligible_for_early_checkin] = current_hotel.settings.is_allow_early_checkin && is_eligible_for_early_checkin(reservation, @data[:is_early_checkin_bundled], early_checkin_addons)
    @data[:is_early_checkin_available_for_hotel] = !current_early_checkin_offer.empty? && current_hotel.settings.is_allow_early_checkin
    @data[:early_checkin_time] = get_early_checkin_time(reservation, @data[:is_early_checkin_bundled], early_checkin_addons)
  end

  def early_checkin_offer
    reservation = current_hotel.reservations.find(params[:id])
    @offer = reservation.current_early_checkin_offer
  end

  def apply_early_checkin_offer
    errors = []
    reservation = current_hotel.reservations.find(params[:reservation_id])
    offer = current_hotel.early_checkin_setups.find(params[:early_checkin_offer_id])
    post_charge_code =  current_hotel.settings.early_checkin_charge_code
    if current_hotel.is_third_party_pms_configured?
      post_ows = PostChargesApi.new(reservation.hotel.id)
      posting_attr_hash = { posting_date: current_hotel.active_business_date, posting_time: Time.now, long_info: t(:upsell_early_checkin), charge: offer.charge, bill_no: '1' }
      result = post_ows.update_post_charges(post_charge_code, reservation.external_id, posting_attr_hash)
      failed_updation = !result[:status]
      errors << 'Unable to update all Charges in External PMS' if failed_updation
    else
      options = {
        is_eod: false,
        amount: post_item[:amount],
        rate_id: nil,
        bill_number: bill_no,
        charge_code: charge_code,
        is_item_charge: true,
        item_details: post_item
      }
      reservation.post_charge(options)
      reservation.update_attributes(is_early_checkin_purchased: true)
    end
    render(json: errors, status: :unprocessable_entity)  unless errors.empty?     
  end

   def bill_print_data
     reservation = current_hotel.reservations.find(params[:id])
     template = params[:is_checkout] == "true" ? current_hotel.printer_templates.checkout_bill_template : current_hotel.printer_templates.checkin_bill_template 
     @printer_data = ViewMappings::Kiosk::BillDetailsMapping.map_kiosk_bill_details(template,reservation)
  end

  def find_by_key_uid
    @reservation = current_hotel.reservations.due_out(current_hotel.active_business_date).joins(:reservation_keys).where("reservation_keys.uid=? AND reservation_keys.is_inactive=false",params[:uid]).first
  end

  def update_key_uid
    reservation = current_hotel.reservations.find(params[:reservation_id])
    reservation.invalidate_key_for_previous_reservations(params[:uid])
    newly_printed_keys = reservation.reservation_keys.where("uid IS NULL")
    if newly_printed_keys.present?
      newly_printed_keys.update_all(uid: params[:uid], is_inactive: false)
    else
      reservation.create_reservation_key("true", 1, params[:uid])
    end
  end

  def delete_addons
    reservation = current_hotel.reservations.find(params[:id])
    reservation.addons.delete(current_hotel.addons.where('id in (?)', params[:addons]))
  end


  private

  #Method to identify whether early checkin can be opted based on the window time configuration
  def is_eligible_for_early_checkin(reservation, is_bundled, early_checkin_addons)
    is_eligible = false
    if is_bundled && early_checkin_addons.empty?
      is_eligible = Time.now.utc >= ActiveSupport::TimeZone[reservation.hotel.tz_info]
       .parse(reservation.hotel.settings.early_checkin_time).utc
    elsif !early_checkin_addons.empty?
      window_time = reservation.hotel.early_checkin_setups.where("addon_id IN (?)", early_checkin_addons).first
      is_eligible = Time.now.utc >= ActiveSupport::TimeZone[reservation.hotel.tz_info]
        .parse(window_time.start_time.in_time_zone(reservation.hotel.tz_info).strftime("%I:%M %p")).utc if window_time
    end
    is_eligible
  end

  def get_early_checkin_time(reservation, is_bundled, early_checkin_addons)
    early_checkin_time = nil
    if is_bundled && early_checkin_addons.empty?
      early_checkin_time = reservation.hotel.settings.early_checkin_time
    elsif !early_checkin_addons.empty?
      window_time = reservation.hotel.early_checkin_setups.where("addon_id IN (?)", early_checkin_addons).first
      early_checkin_time = window_time.start_time.in_time_zone(reservation.hotel.tz_info).strftime("%I:%M %p") if window_time
    end
    early_checkin_time.to_s
  end

  def cards_valid?
    params[:guest_detail_id] || params[:company_id] || params[:travel_agent_id]
  end

  def emails_valid?(emails)
    !emails.andand.select { |email| email.present? && !email.match(/\A[^@]+@[^@]+\z/) }.present?
  end

  def send_confirmation_emails(emails, tax_details)
    @reservation.tax_details = tax_details if tax_details.present?
    emails.andand.each do |email|
      begin
        ReservationMailer.send_confirmation_number_mail(@reservation, email).deliver!
      rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
        logger.error "Standalone PMS Confirmation Number Sending Failed - " \
                     "Email not sent confirmation number #{@reservation.confirm_no} to #{email} : #{e.message}"
      end
    end
  end

  def update_guest!
    guest_detail = GuestDetail.find(params[:guest_detail_id])
    @reservation.reservations_guest_details.create!(guest_detail_id: guest_detail.id, is_primary: true)
  end

  def payment_type_attributes
    payment_type_params = params[:payment_type]
    attributes = {}

    if payment_type_params.key?(:type_id)
      payment_type = PaymentType.find(payment_type_params[:type_id])

      if payment_type.credit_card?
        attributes = {
          payment_type: payment_type.value,
          credit_card_type: payment_type_params[:credit_card_type_id],
          card_name: payment_type_params[:card_name],
          card_expiry: payment_type_params[:expiry_date],
          bill_number: 1
        }
        attributes[:session_id] = payment_type_params[:session_id] if payment_type_params.key?(:session_id)
        attributes[:card_number] = payment_type_params[:card_number] if payment_type_params.key?(:card_number)

        # CICO-9283 - iPage credit card transaction
        attributes[:is_six_payment] = false
        if payment_type_params.key?(:isSixPayment) && payment_type_params[:isSixPayment]
          attributes[:is_six_payment] = true
          attributes[:token] = payment_type_params[:token]
        end
      else
        attributes = {
          payment_type: payment_type.value,
          bill_number: 1
        }
      end
    end

    if payment_type_params.key?(:payment_method_id)
      payment_method = PaymentMethod.find(payment_type_params[:payment_method_id])

      attributes = {
        payment_type: payment_method.payment_type.value,
        credit_card_type: payment_method.credit_card_type.to_s,
        card_name: payment_method.card_name,
        card_expiry: payment_method.card_expiry,
        mli_token: payment_method.mli_token,
        bill_number: 1,
        is_swipe: false
      }
    end

    attributes
  end

  def reservation_attributes
    arrival_time = params[:arrival_time].present? ? params[:arrival_time] : "00:00"
    departure_time = params[:departure_time].present? ? params[:departure_time] : "23:59:59"

    reservation = {
      hotel_id: current_hotel.id,
      arrival_date: params[:arrival_date],
      dep_date: params[:departure_date],
      company_id: params[:company_id],
      travel_agent_id: params[:travel_agent_id],
      reservation_type_id: params[:reservation_type_id],
      source_id: params[:source_id],
      market_segment_id: params[:market_segment_id],
      booking_origin_id: params[:booking_origin_id],
      status: :RESERVED,
      is_hourly: params[:is_hourly]
    }
    reservation[:arrival_time] = getDatetime(params[:arrival_date], arrival_time, current_hotel.tz_info) if params[:arrival_time].present?
    reservation[:departure_time] = getDatetime(params[:departure_date], departure_time, current_hotel.tz_info) if params[:departure_time].present?
    reservation
  end

  def daily_instance_attributes(day, room_id = nil)
    stay_date = nil
    if day.is_a?(Date)
      day = day.to_s
    end
    if room_id
      params[:stay_dates].map {|stay| stay.map { |a| stay_date = a if (a[:date] == day && a[:room_id] == room_id); } } if params[:stay_dates]
    else
      params[:stay_dates].map {|stay| stay.map { |a| stay_date = a if a[:date] == day  } } if params[:stay_dates]
    end

    if stay_date
      @begin_date = @reservation.arrival_date
      @begin_time = @reservation.arrival_time.andand.in_time_zone(current_hotel.tz_info).andand.utc
      @end_time = @reservation.departure_time.andand.in_time_zone(current_hotel.tz_info).andand.utc
      rate = Rate.find(stay_date[:rate_id])
      room_type = room_id ? Room.find(room_id).room_type : RoomType.find(stay_date[:room_type_id])
      adults = stay_date[:adults_count]
      children = stay_date[:children_count] || 0
      infants = stay_date[:infants_count] || 0
      actual_rate_amount = rate.is_hourly_rate ? rate.calculate_hourly_rate_amount(@begin_date, room_type, @begin_time, @end_time) : rate.calculate_rate_amount(day, room_type, adults, children)
      rate_amount = stay_date[:rate_amount] || actual_rate_amount
      rate_amount = stay_date[:date].to_date == @begin_date ? rate_amount : 0 if rate.is_hourly_rate
        {
          reservation_date: day,
          adults: adults,
          children: children,
          infants: infants,
          rate_id: rate.andand.id,
          room_type_id: room_type.andand.id,
          status: @reservation.status,
          original_rate_amount: actual_rate_amount,
          rate_amount: rate_amount,
          currency_code: current_hotel.default_currency
        }
    end
  end

  def stay_attributes(day, room_id = nil)
    stay_date = nil
    if day.is_a?(Date)
      day = day.to_s
    end
    # Get the stay attributes that matches date and room id from array of array, if room_id is present
    if room_id
      params[:stay_dates].map {|stay| stay.map { |a| stay_date = a if (a[:date] == day && a[:room_id] == room_id); } } if params[:stay_dates]
    # Get the stay attributes that matches date from array of array
    else
      params[:stay_dates].map {|stay| stay.map { |a| stay_date = a if a[:date] == day  } } if params[:stay_dates]
    end
    # Build room_type if no room type is present in params.
    stay_date[:room_type_id] = (room_id ? Room.find(room_id).room_type_id : stay_date[:room_type_id] ) if stay_date
    stay_date
  end

  def addons_attributes
    params[:addons].map do |addon_attribute|
      addon = Addon.find(addon_attribute[:id])

      {
        addon_id: addon_attribute[:id],
        quantity: addon_attribute[:quantity],
        price: addon.amount,
        is_inclusive_in_rate: false
      }
    end
  end

  # Retrieve the reservation based on Current Hotel
  def retrieve
    @reservation = current_hotel.reservations.find(params[:id])
  end

  # Retrieve the reservation based on given reservation ID
  def get_reservation
    @reservation = Reservation.find(params[:id])
    fail I18n.t(:invalid_origin_id) unless @reservation.present?
  end

  def reservation_update_attributes
    attributes = params.slice(:arrival_date, :departure_date, :reservation_type_id, :source_id,
                              :market_segment_id, :booking_origin_id, :arrival_time, :departure_time)
    arrival_time = params[:arrival_time].present? ? params[:arrival_time] : "00:00"
    departure_time = params[:departure_time].present? ? params[:departure_time] : "23:59:59"
    attributes[:arrival_time] = getDatetime(params[:arrival_date], arrival_time, current_hotel.tz_info) if params[:arrival_time].present?
    attributes[:departure_time] = getDatetime(params[:departure_date], departure_time, current_hotel.tz_info) if params[:departure_time].present?

    attributes
  end

  def getDatetime(date, time, tz_info)
    ActiveSupport::TimeZone[tz_info].parse(date.to_s + ' ' + time.to_s)
  end
  
  def send_cancellation_email
    refund_amount   = 0
    total_payments  = 0
    current_charges = 0
    
    bill_one = @reservation.bills.present? ? @reservation.bills.first : Bill.create(bill_number: 1, reservation_id: @reservation.id)
    # Get the credit card type
    unless bill_one.andand.financial_transactions.empty?
      total_payments = NumberUtility.default_amount_format(bill_one.andand.financial_transactions.credit.sum(:amount).to_f).to_f
      current_charges = NumberUtility.default_amount_format(@reservation.bill_one.andand.financial_transactions.debit.sum(:amount).to_f).to_f
    end
    
    refund_amount = (total_payments-current_charges)
    ReservationMailer.guest_send_cancellation_email(@reservation, refund_amount).andand.deliver
  end

  def room_move_inhouse_reservation(reservation, old_room, old_rate_amount)
    if reservation.status === :CHECKEDIN
      current_daily_instance = reservation.current_daily_instance
      if reservation.is_hourly

        # Step -01 Update old Room Status to DIRTY and VACANT
        old_room.hk_status = :DIRTY
        old_room.is_occupied = false
        old_room.save!

        # Step -02 Update new Room Status to OCCUPIED
        new_room = current_daily_instance.room
        new_room.is_occupied = true
        new_room.save!

        # Step -03 Post cabin charge when room change/externd stay
        post_rate_amount = current_daily_instance.rate_amount.to_f - old_rate_amount
        options = {
                    is_eod: false,
                    amount: post_rate_amount, # Calculate the actual hourly rate amount
                    rate_id: current_daily_instance.andand.rate_id, # rate id of the reservation
                    bill_number: 1,
                    charge_code: reservation.daily_instances.first.rate.charge_code,
                    post_date: current_hotel.active_business_date,
                    hourly_reservation_is_edit: true
                  }
        reservation.post_charge(options) if post_rate_amount != 0 # when shorting or calling again edit this amount became zero.
      end
      # Hourly inventories map new updated info
      HourlyInventoryDetail.map_inventories(@reservation)
    end
  end
end
