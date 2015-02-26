class Staff::StaycardsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  def staycard
    status = FAILURE
    errors = []

    selected_reservation = Reservation.find(params[:id])
    third_party_connected = current_hotel.is_third_party_pms_configured?
    # Sync the reservation with the external PMS
    if third_party_connected
      result = selected_reservation.sync_booking_with_external_pms
      # if there is error in sync call, display the error
      if !result[:status] && result[:message].match(/PASSWORD IS NOT VALID/).present?
        response =  { 'status' => status, 'data' => {}, 'errors' => result[:message] }
        render json: response
        return
      end
      # Sync invoice
      selected_reservation.sync_bills_with_external_pms
    end
    selected_reservation.reload

    # Find all other reservations for this user
    reservations = selected_reservation.primary_guest.reservations.where(hotel_id: current_hotel.id).order(:confirm_no)

    @guest_card_hash = ViewMappings::StayCardMapping.map_guest_card_contact_info(selected_reservation) if selected_reservation.guest_details
    @stay_card_hash = ViewMappings::StayCardMapping.map_to_stay_card_data(selected_reservation, current_hotel.active_business_date, result[:booking_attributes])
    @wakeup_hash = selected_reservation.get_wakeup_time
    @country = Country.find(:all, order: 'name').map do |country|
      [country.name, country.id]
    end

    @reservation_id_hash = {
      'current_reservations_arr' => ViewMappings::StayCardMapping.build_reservation_ids(reservations.current_reservations(current_hotel.active_business_date), current_hotel),
      'history_reservations_arr' => ViewMappings::StayCardMapping.build_reservation_ids(reservations.history_reservations(current_hotel.active_business_date), current_hotel),
      'upcoming_reservations_arr' => ViewMappings::StayCardMapping.build_reservation_ids(reservations.upcoming_reservations(current_hotel.active_business_date), current_hotel)
    }

    guest_detail = Guest_detail.find(@guest_card_hash['guest_detail_id'])
    @payment_records = guest_detail.payment_methods
    response =  { 'status' => SUCCESS, 'data' => { reservation_list: @reservation_id_hash }, 'errors' => errors }
    render json: response
  end

  # Method to fetch the stay card details of the selected confirmation number
  def reservation_details
    confirmation_number = params[:reservation]
    reservation = current_hotel.reservations.find_by_confirm_no(confirmation_number)
    logger = Logger.new("#{Rails.root}/log/staycard_performance.log")
    third_party_connected = current_hotel.is_third_party_pms_configured?
    t1 = Time.now
    logger.debug 'Reservation Details API---'
    if third_party_connected
      # Sync the reservation with the external PMS if hotel connected to third party pms
      result = reservation.sync_booking_with_external_pms
      logger.debug "Reservation Details API --Sync Booking With External PMS -#{confirmation_number} -- #{(Time.now - t1) * 1000}"

      t2 = Time.now
      # Sync Guest attributes with external PMS if its connected to third party pms
      reservation.sync_guest_with_external_pms
      logger.debug "Reservation Details API --Sync Guest With External PMS -#{confirmation_number} -- #{(Time.now - t2) * 1000}"
      t3 = Time.now
      # Sync invoice details with external pms if hotel connected to third party pms
      reservation.sync_bills_with_external_pms if result[:status]
      logger.debug "Reservation Details API --Sync Bills With External PMS -#{confirmation_number} -- #{(Time.now - t3) * 1000}"
    end
    t4 = Time.now
    # @reservation_card_hash = get_stay_card_data(reservation)
    booking_attributes = result[:booking_attributes] if(result.present? && result[:booking_attributes].present?)
    @reservation_card_hash = ViewMappings::StayCardMapping.map_to_stay_card_data(reservation, current_hotel.active_business_date, booking_attributes)
    logger.debug "Reservation Details API --reservation card hash -#{confirmation_number} -- #{(Time.now - t4) * 1000}"

    response = { status: SUCCESS, data: { reservation_card: @reservation_card_hash }, errors: [] }
    render json: response
  end
  
  # CICO-9427 Display existing addons in pop up 
  def reservation_addons
    reservation = Reservation.find(params[:reservation_id])
    room_no = reservation.current_daily_instance.andand.room.andand.room_no.to_s
    duration_of_stay = reservation.is_hourly ? "1" : reservation.total_nights
    existing_packages = reservation.reservations_addons.map do | res_addon|
      {
        package_id: res_addon.addon.id,
        package_name: res_addon.addon.name,
        count: res_addon.quantity,
        price_per_piece: res_addon.addon.amount,
        amount_type: res_addon.addon.amount_type.description,
        post_type: res_addon.addon.post_type.description,
        is_inclusive: reservation.current_daily_instance.rate.rates_addons.where(:addon_id => res_addon.addon.id).first.andand.is_inclusive_in_rate
      }
    end
    render json: { status: SUCCESS, duration_of_stay: duration_of_stay, room_no: room_no, existing_packages: existing_packages, errors: [] }
  end

  # Method to call email or phone blank
  def validate_email_phone
    render partial: 'modals/validateEmailAndPhone'
  end

  # Validate e-mail for checkout API call.
  def validate_email
    render partial: 'modals/validateEmail'
  end

  # fetch reservation credit cards
  def get_credit_cards
    reservation = Reservation.find(params[:reservation_id])
    bill_number = params[:bill_number] || 1 # default to bill #1 if not provided
    
    reservation_credit_cards = ViewMappings::StayCardMapping.get_credit_cards(reservation, bill_number)
    
    reservation_credit_cards = reservation_credit_cards.merge({has_accompanying_guests: !reservation.accompanying_guests.empty?})
    render json: { status: SUCCESS, data: reservation_credit_cards, errors: [] }
  end

  def unlink_credit_card
    reservation = Reservation.find(params[:reservation_id])

    # Delete credit card on bill #1 unless a bill number is passed
    bill_number = params[:bill_number] || 1

    reservation.payment_methods.where(bill_number: bill_number).first.andand.destroy
    render json: { status: SUCCESS, data: {}, errors: [] }
  end
end
