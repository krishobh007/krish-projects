class Guest::ReservationsController < ApplicationController
  before_filter :check_session, except: :qr_code_image
  # Get a guest's bookings by user_id or (email AND hotel code or chain code).
  def get_all_bookings
    results = []
    user_id = params[:user_id]
    email = params[:email]
    hotel_code = params[:hotel_code]
    chain_code = params[:chain_code]

    # Get the hotel for the hotel code parameter
    hotel = Hotel.find_by_code(params[:hotel_code])

    # Get the chain for the chain code parameter
    chain = HotelChain.find_by_code(params[:chain_code])

    unless user_id || (email && (hotel || chain))
      errors = 'User ID or (email and either valid hotel code or chain code) is required'
    end
    if !errors
      hotel_id = hotel ? hotel.id : nil
      chain_id = chain ? chain.id : nil

    # Get the reservation information for the input parameters
      reservations = Reservation.select('id, confirm_no,status_id,arrival_date, dep_date,  hotel_id, lobby_status').order('arrival_date asc').by_user_and_hotel(user_id, email, hotel_id, chain_id)
    # Structure the JSON results
      results = ViewMappings::GuestZest::DashboardMapping.map_all_reservations(reservations)
      render json: { data: results, status: SUCCESS, errors: [] }
    else
      logger.debug 'Get All Bookings API request invalid: ' + errors
      render json: { data: [], status: FAILURE, errors: [errors] }
    end
  end

  def set_lobby_status
    reservation = Reservation.find(params[:id])
    reservation.lobby_status = params[:lobby_status]

    unless params[:lobby_status]
      errors = 'Please provide lobby status'
    end

    if reservation.update_attribute(:lobby_status, params[:lobby_status]) && !errors

      if reservation.lobby_status
        time = Time.new
        reservation.primary_guest.user.update_attribute(:sb_last_seen_at , time.strftime('%Y-%m-%d %H:%M:%S')) if reservation.primary_guest.user.present?
      end

      results =  {
        lobby_status: reservation.lobby_status.to_s
      }

      render json: { data: results, status: SUCCESS, errors: [] }
    else
      logger.debug 'Set Lobby Status API request invalid: ' + errors
      render json: { data: [], status: FAILURE, errors: [errors] }
    end
  end

  def get_booking_details
    reservation = Reservation.find(params[:reservation_id])

    if reservation.hotel.is_third_party_pms_configured?
      # Sync the booking with the external PMS to ensure all data is loaded
      reservation.sync_booking_with_external_pms(call_sync_notes = false)

      # Sync Invoice
      reservation.sync_bills_with_external_pms
    end

    booking_details = ViewMappings::GuestZest::DashboardMapping.map_reservation_details(reservation)

    if (booking_details[:status] == Setting.reservation_view_status[:checking_in]) && (reservation.is_first_time_checkin)
      reservation.update_attributes(is_first_time_checkin: false)
    end

    render json: { data: booking_details, status: SUCCESS, errors: [] }
  end

  def reservation_room_upsell_options
    reservation = Reservation.find(params[:id])
    if reservation.current_daily_instance && reservation.current_daily_instance.room_type
      upsell_options = ViewMappings::RoomTypesMapping.upsell_options(reservation)
    else
      upsell_options = {}
    end
    render json: { status: SUCCESS, data: upsell_options, errors: [] }
  end

  def upgrade_room
    data, errors, status = {}, [], FAILURE
    reservation = Reservation.find(params[:reservation_id])
    room_no = params[:upgrade_room_number]

    upsell_amount = reservation.hotel.upsell_amounts.find(params[:upsell_amount_id]).amount.to_f

    result = reservation.upgrade_room(upsell_amount, room_no, :ZEST)
    if result[:status]  && result[:errors].blank?
      reservation.update_attributes(is_upsell_applied: true)
      status = SUCCESS
      data[:message] = 'Success'
      data[:upgrade_room_number] = params[:upgrade_room_number]
      data[:upgrade_room_type_name] = reservation.hotel.rooms.find_by_room_no(params[:upgrade_room_number]).andand.room_type.room_type_name
    else
      errors << 'Unable to apply Upsell with External PMS'
    end
    render json: { status: status, data: data, errors: errors }
  end

  # API to checkin the reservation
  def checkin
    reservation = Reservation.find(params[:reservation_id])
    signature_image = Base64.decode64(params[:signature_image]) if params[:signature_image]
    send_email = params[:send_email]
    errors = []
    data = {}
    status = FAILURE
    result = reservation.checkin(signature_image, :ZEST)
    if result[:success]
      reservation.sync_booking_with_external_pms
      status = SUCCESS
      data = { check_in_status: 'success' }
    else
      errors << 'Could not set room for reservation in External PMS'
      logger.error "Could not set room for reservation: #{reservation.id}"
    end
    render json: { status: status, data: data, errors: errors }
  end

  def create_reservation_key
    reservation = Reservation.find(params[:id])
    if reservation
      room_no = reservation.current_daily_instance.room.andand.room_no if reservation
      key_data = {}
      email = ''

      # If QR code is present then return it , else create new QR Code and return .
      if !reservation.reservation_keys.first.present?
        key_data = ReservationKey.create!(reservation_id: reservation.id, number_of_keys: 1, room_number: room_no, qr_data: reservation.qr_code)
        # Send email if key set up demands that
      else
        # Read key delivery settings and provide key base don the configuration.
        key_data = reservation.reservation_keys.first
      end

      key_data['message'] = ''
      key_data['is_smartphone'] = 'true' # As per Mobile Team request

      # Send email if key set up demands that
      # call key api to decide which key system to send -- Send true for called_from_rover parameter

      key_api = KeyApi.new(reservation.hotel_id, false)
      result = key_api.create_key(reservation, key_data, email, request.host_with_port)

      if result[:status]
        render json: { status: SUCCESS, data: result[:data], errors: [] }
      else
        render json: { status: FAILURE, errors: result[:errors], data: {} }
      end
    else
      render json: { status: FAILURE, data: {}, errors: ['Invalid Reservation'] }
    end
  end

  def qr_code_image
    reservation_key = ReservationKey.find(params[:key_id])
    send_data reservation_key.qr_data, type: 'image/png', disposition: 'inline'
  end

  def checkout
    data = {}
    status = FAILURE
    errors = []
    result = {}
    reservation =  Reservation.find(params[:reservation_id])
    if reservation.present?
      hotel = reservation.hotel
      if reservation.status === :CHECKEDIN &&  hotel.active_business_date <= reservation.dep_date
        result = reservation.checkout_with_external_pms

        if result[:status]
          Action.record!(reservation, :CHECKEDOUT, :ZEST, hotel.id)
          if reservation.update_checkout_details
            checkout_message = hotel.settings.guest_zest_checkout_complete_message ? hotel.settings.guest_zest_checkout_complete_message : 'Thank You'
            data = { 'checkout_message' => checkout_message }
            status = SUCCESS
          else
            logger.error "Could not update checkout for reservation: #{reservation.id} in StayNTouch"
            errors << 'Unable to update checkout details in StayNTouch'
          end
        else
          logger.error "Could not checkout reservation: #{reservation.id} in External PMS"
          errors << 'Unable to update checkout in External PMS'
        end
      else
        errors << 'Invalid reservation status/departure date'
        logger.error "Invalid Reservation status/departure date for checkout in reservation: #{reservation.id}"
      end
    end
    render json: { status: status, data: data, errors: errors }
  end

  def apply_late_checkout
    data, status, errors, result = {}, FAILURE, [], {}

    reservation = Reservation.find(params[:reservation_id])
    late_checkout_offer = LateCheckoutCharge.find(params[:late_checkout_offer_id])
    applied_late_checkout = reservation.apply_late_checkout(params, :ZEST)
    begin
      reservation.send_late_checkout_staff_alert_emails(applied_late_checkout[:status])
    rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
      @logger ||= Logger.new('log/EmailNotifications.log')
      @logger.info "Warning: Late checkout - Staff Alert - Email not sent to #{recipient} : #{e.message}"
    end
    if applied_late_checkout[:status]
      data['currency'] = reservation.hotel.default_currency ? reservation.hotel.default_currency.andand.symbol.to_s : ''
      data['time'] = late_checkout_offer.extended_checkout_time.andand.strftime('%-I%p').to_s
      data['amount'] = number_to_currency(late_checkout_offer.extended_checkout_charge.to_i, precision: 0,  unit: "").to_s

      status = SUCCESS
    end

    render json: { status: status, data: data, errors: errors }
  end

  def auto_assign_room
    data, status, errors, result = {}, FAILURE, [], {}
    assigned = false
    reservation =  Reservation.find(params[:reservation_id])
    data['room_assigned'] = 'false'

    if reservation.present?
      available_rooms = Room.get_available_rooms(reservation.hotel, reservation.current_daily_instance.room_type)
      room_for_assign = available_rooms.select { |item| item['room_status'] == :CLEAN.to_s && item['room_status'] == :INSPECTED.to_s && item['fo_status'] == Ref::FrontOfficeStatus[:VACANT].value }.first
      room = reservation.hotel.rooms.where(room_no: room_for_assign['room_number']).first if room_for_assign

      if room.present?
        if reservation.hotel.is_third_party_pms_configured?
          upcoming_reservation_daily_instances = reservation.daily_instances.where('reservation_date >= ?', reservation.hotel.active_business_date)
          result = reservation.assign_room_with_external_pms(room_for_assign['room_number'])

          if result[:status]
            status = SUCCESS
            assigned = true

            upcoming_reservation_daily_instances.each do |daily_instance|
              daily_instance.update_attributes(room_id: room.id)
            end

            room.hk_status = Ref::HousekeepingStatus[:NOTREADY]
            room.save

            data['room_assigned'] = 'true'
            data['room_number'] = room_for_assign['room_number']
          end
        end
      end
    end

    errors = ['We are still busy getting your room ready! Please check back a little later!']  unless assigned

    render json: { status: status, data: data, errors: errors }
  end

  def search
    data, status, errors, result = {}, FAILURE, [], {}

    user = User.find(params[:user_id])

    reservations = Reservation.joins(:hotel)
      .joins('INNER JOIN reservations_guest_details ON reservations_guest_details.reservation_id = reservations.id')
      .joins('INNER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id')
      .where('hotels.hotel_chain_id = :hotel_chain_id AND reservations.confirm_no = :confirm_no AND guest_details.last_name = :last_name ' \
             'AND reservations_guest_details.is_primary = true',
             hotel_chain_id: user.hotel_chain_id, confirm_no: params[:confirm_no], last_name: user.guest_detail.last_name).uniq
    reservation = reservations.first

    if reservation.present?
      data['is_linked_to_user'] = 'true'
      status = SUCCESS
      if reservation.guest_details.where('user_id IS NOT NULL').count == 0
        data = ViewMappings::GuestZest::DashboardMapping.map_reservation_summary(reservation)
        data['message'] = I18n.t(:reservation_found)
        data['is_linked_to_user'] = 'false'
      else
        data['message'] = I18n.t(:already_linked_reservation)
      end
    else
      errors <<  I18n.t(:reservation_not_found)
    end
    render json: { status: status, data: data, errors: errors }
  end

  def get_recent_reservation
    data, status, errors = {}, FAILURE, []
    recent_reservation = current_user.recent_reservation
    yotel = Hotel.find_by_code("DOZERQA")
    recent_reservation.sync_booking_with_external_pms(call_sync_notes = false) if recent_reservation.present?
    data = ViewMappings::GuestZest::DashboardMapping.map_reservation_details(recent_reservation, yotel)
    status = SUCCESS
    render json: { status: status, data: data, errors: errors }
  end
end

