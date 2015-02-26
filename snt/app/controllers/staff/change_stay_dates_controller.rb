class Staff::ChangeStayDatesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  ROOM_AVAILABLE = 'room_available'
  ROOM_TYPE_AVAILABLE = 'room_type_available'
  NOT_AVAILABLE = 'not_available'
  NO_ROOM_MOVE = 'no_room_move'
  TO_BE_UNASSIGNED = 'to_be_unassigned'
  MAINTENANCE = 'maintenance'

  # Main page for rendering whole information.
  def show_page
    data, status, errors = {} , FAILURE, []
    begin
      reservation = Reservation.find(params[:reservation_id])
    rescue ActiveRecord::RecordNotFound => ex
      logger.error "Could not find reservation: #{params[:reservation_id]}"
      errors << ex.message
    end
    active_business_date = current_hotel.active_business_date
    top_header_values = ViewMappings::StayCardMapping.get_reservation_header(reservation, active_business_date)
    data, status, errors = top_header_values , SUCCESS, []
    respond_to do |format|
      format.html { render partial: 'change_stay', locals: { data: data } }
      format.json { render json: { status: status, data: data, errors: errors } }
    end
  end

  def show
    data = {}
    errors = []

    reservation = Reservation.find(params[:reservation_id])

    from_date = params.key?(:from_date) ? Date.parse(params[:from_date]) : reservation.availability_lower_limit
    to_date = params.key?(:to_date) ? Date.parse(params[:to_date]) : reservation.availability_upper_limit

    current_daily_instance = reservation.current_daily_instance
    room = current_daily_instance.room
    room_type = current_daily_instance.room_type
    rate = current_daily_instance.rate
    rate_code = rate.andand.rate_code

    if current_hotel.is_third_party_pms_configured?
      api = CalendarApi.new(current_hotel.id)
      api_result = api.fetch_calendar(from_date, to_date, current_daily_instance.adults, current_daily_instance.children, room_type.room_type,
                                      rate_code)

      availability_data = api_result[:data]

      errors << I18n.t(:external_pms_failed) unless api_result[:status]
    else
      room_type_room_count = current_hotel.rooms.exclude_pseudo.group(:room_type_id).where('room_type_id = ?', room_type.id).count
      options = { rates: [rate], room_types: [room_type], override_restrictions: true,  room_type_room_count: room_type_room_count }
      availability = Availability.new(current_hotel, (from_date..to_date).to_a, options)
      availability_data = ViewMappings::CalendarMapping.map_standalone_availability(reservation, availability.data)
    end

    unless errors.present?
      data = ViewMappings::CalendarMapping.map_availability_information(reservation, current_daily_instance, room_type, rate_code, availability_data)

      data[:room_ready_status] = room.andand.hk_status.to_s
      data[:use_inspected] = current_hotel.settings.use_inspected.to_s
      data[:use_pickup] = current_hotel.settings.use_pickup.to_s
      data[:checkin_inspected_only] = current_hotel.settings.checkin_inspected_only.to_s
    end

    data[:room_ready_status] = room.andand.hk_status.to_s
    data[:use_inspected] = current_hotel.settings.use_inspected.to_s
    data[:use_pickup] = current_hotel.settings.use_pickup.to_s
    data[:checkin_inspected_only] = current_hotel.settings.checkin_inspected_only.to_s

    result = {
      status: errors.empty? ? SUCCESS : FAILURE,
      data: data,
      errors: errors
    }

    respond_to do |format|
      format.html { render partial: 'change_stay', locals: result }
      format.json { render json: result }
    end
  end

  # Update the stay dates. Called when arrival or departure dates are changed on calendar.
  def update
    reservation = Reservation.find(params[:reservation_id])

    if current_hotel.is_third_party_pms_configured?
      result = external_pms_status(reservation)
    else
      result = standalone_pms_status(reservation)
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  # Confirm the stay dates change. Called when the confirm button is clicked after changing the stay dates.
  def confirm
    reservation = Reservation.find(params[:reservation_id])
    new_arrival_date = Date.parse(params[:arrival_date])
    new_dep_date = Date.parse(params[:dep_date])

    if current_hotel.is_third_party_pms_configured?
      result = confirm_external_pms(reservation, new_arrival_date, new_dep_date)
    else
      result = confirm_standalone_pms(reservation, new_arrival_date, new_dep_date)
    end

    respond_to do |format|
      format.json { render json: result }
    end
  end

  private

  # Check if the stay has shortened
  def stay_has_shortened(reservation, new_arrival_date, new_dep_date)
    new_arrival_date >= reservation.arrival_date && new_dep_date <= reservation.dep_date
  end

  # Check if a stay date change is allowed
  def stay_change_allowed(reservation, new_arrival_date, new_dep_date)
    business_date = current_hotel.active_business_date

    ((reservation.status === :RESERVED && new_arrival_date >= business_date) || (reservation.status === :CHECKEDIN &&
      new_arrival_date == reservation.arrival_date)) &&
    new_dep_date >= business_date && new_arrival_date <= new_dep_date
  end

  def external_pms_status(reservation)
    errors = []
    availability_status = ROOM_AVAILABLE

    current_daily_instance = reservation.current_daily_instance
    room = current_daily_instance.room
    room_type = current_daily_instance.room_type

    current_arrival_date = reservation.arrival_date
    current_dep_date = reservation.dep_date

    new_arrival_date = Date.parse(params[:arrival_date])
    new_dep_date = Date.parse(params[:dep_date])

    if stay_change_allowed(reservation, new_arrival_date, new_dep_date)
      # If stay has extended, room is assigned, and reservation is reserved, check for availability
      if room && !stay_has_shortened(reservation, new_arrival_date, new_dep_date)
        if reservation.status === :RESERVED
          room_available = true

          # Check for availability for earlier arrival date
          if new_arrival_date < current_arrival_date
            room_available = room.available_between?(new_arrival_date, current_arrival_date - 1.day)
          end

          # Check for availability for later departure date
          if room_available && new_dep_date > current_dep_date
            room_available = room.available_between?(current_dep_date + 1.day, new_dep_date)
          end

          availability_status = ROOM_TYPE_AVAILABLE unless room_available
        elsif reservation.status === :CHECKEDIN && new_dep_date > current_dep_date
          # Ensure no unmoveable rooms are reserved during new stay
          if room.unmoveable_between?(current_dep_date + 1.day, new_dep_date)
            availability_status = NOT_AVAILABLE
          end
        end
      end
    else
      errors << 'Invalid stay dates selected'
    end

    if errors.empty?
      result = {
        status: SUCCESS,
        data: { availability_status: availability_status },
        errors: []
      }

      if availability_status == ROOM_TYPE_AVAILABLE
        result[:data].merge(ViewMappings::FeaturesMapping.map_room_filters(reservation, current_hotel))
        result[:data][:rooms] = Room.get_available_rooms(current_hotel, room_type)
      end
    else
      logger.debug errors.to_s
      result = { status: FAILURE, data: nil, errors: errors }
    end

    result
  end

  def standalone_pms_status(reservation)
    errors = []
    availability_status = ROOM_AVAILABLE
    restrictions = []
    preassigned_guest = {}

    current_daily_instance = reservation.current_daily_instance
    room = current_daily_instance.room
    room_type = current_daily_instance.room_type
    rate = current_daily_instance.rate

    current_arrival_date = reservation.arrival_date
    current_dep_date = reservation.dep_date

    new_arrival_date = Date.parse(params[:arrival_date])
    new_dep_date = Date.parse(params[:dep_date])

    if stay_change_allowed(reservation, new_arrival_date, new_dep_date)
      # If stay has extended, room is assigned, and reservation is reserved, check for availability
      if room
        room_type_room_count = current_hotel.rooms.exclude_pseudo.group(:room_type_id).where('room_type_id = ?', room_type.id).count
        options = { rates: [rate], room_types: [room_type], override_restrictions: true,  room_type_room_count: room_type_room_count }
        availability = Availability.new(current_hotel, (new_arrival_date..new_dep_date).to_a, options)
        # new_dep_date != current_dep_date
        #
        restrictions = availability.applicable_restrictions(current_arrival_date, current_dep_date)
        unless stay_has_shortened(reservation, new_arrival_date, new_dep_date)
          room_type_available = true
          preassigned_reservations = []

          # Check for availability for earlier arrival date
          if new_arrival_date < current_arrival_date
            room_type_available = availability.room_type_between?(room_type, new_arrival_date, current_arrival_date - 1.day)
            preassigned_reservations = room.preassigned_between(new_arrival_date, current_arrival_date - 1.day) if room_type_available
          end

          # Check for availability for later departure date
          if room_type_available && new_dep_date > current_dep_date
            room_type_available = availability.room_type_between?(room_type, current_dep_date + 1.day, new_dep_date)
            preassigned_reservations = room.preassigned_between(current_dep_date + 1.day, new_dep_date) if room_type_available
          end

          if room_type_available
            # Check if room is preassigned
            if preassigned_reservations.present?
              preassigned_reservation = preassigned_reservations.first

              if preassigned_reservation.no_room_move
                availability_status = NO_ROOM_MOVE
              else
                availability_status = TO_BE_UNASSIGNED
                preassigned_guest = {
                  name: preassigned_reservation.primary_guest.andand.full_name,
                  arrival_date: preassigned_reservation.arrival_date.strftime('%Y-%m-%d')
                }
              end
            end
          else
            availability_status = NOT_AVAILABLE
          end
        end
      end
    else
      errors << 'Invalid stay dates selected'
    end

    if errors.empty?
      display_restrictions = restrictions.map do |restriction|
        { name: Ref::RestrictionType[restriction[:restriction_type_id]].description.to_s, days: restriction[:days] }
      end

      result = {
        status: SUCCESS,
        data: { availability_status: availability_status, restrictions: display_restrictions, preassigned_guest: preassigned_guest },
        errors: []
      }
    else
      logger.debug errors.to_s
      result = { status: FAILURE, data: nil, errors: errors }
    end

    result
  end

  def confirm_external_pms(reservation, new_arrival_date, new_dep_date)
    errors = []
    update_reservation = { status: true }

    change_room_in_external_pms(reservation) if params.key?(:room_number)

    if update_reservation[:status]
      current_room_type_id = reservation.current_daily_instance.room_type_id
      current_rate_id = reservation.current_daily_instance.rate_id

      # Call OWS to modify the booking dates
      api = ReservationApi.new(current_hotel.id)
      booking_result = api.modify_booking(reservation.confirm_no, time_span: { arrival_date: new_arrival_date, dep_date: new_dep_date },
                                                                  room_type_id: current_room_type_id, rate_id: current_rate_id)

      if booking_result[:status]
        ReservationImporter.new(reservation).sync_booking_attributes(booking_result[:data])
        reservation.update_attributes(is_opted_late_checkout: false) if reservation.is_opted_late_checkout
      else
        errors << 'Unable to change stay dates. Please proceed to Front Desk for further assistance.'
        # errors << I18n.t(:external_pms_failed)
      end
    end

    { status: errors.empty? ? SUCCESS : FAILURE, data: nil, errors: errors }
  end

  def change_room_in_external_pms(reservation)
    old_room = reservation.current_daily_instance.room
    new_room = current_hotel.rooms.find_by_room_no(params[:room_number].strip) if params[:room_number]
    if new_room.present?
      if old_room.room_no != new_room.room_no
        assign_room_result = reservation.assign_room_with_external_pms(new_room.room_no)
        if assign_room_result[:status]
          # As per CICO - 5987, SNT database should updated with 3rdparty PMS return Room Number.
          new_room = assign_room_result[:room_no] ? current_hotel.rooms.find_by_room_no(assign_room_result[:room_no].strip) : new_room
          changed_attributes = { room_id: new_room.id }
          reservation.modify_booking(changed_attributes)
          update_reservation[:status] = true
        else
          update_reservation[:status] = false
        end
      end
    end
  end

  def confirm_standalone_pms(reservation, new_arrival_date, new_dep_date)
    errors = []
    old_instance_dates = []
    new_instance_dates = []
    current_daily_instance = reservation.current_daily_instance
    old_instance_dates = reservation.daily_instances.pluck(:reservation_date)
    adults = current_daily_instance.adults
    children = current_daily_instance.children
    infants = current_daily_instance.infants
    rate = current_daily_instance.rate
    room_type = current_daily_instance.room_type
    room = current_daily_instance.room
    old_dep_date = reservation.dep_date
    # As part of CICO-9521, we are not updating current daily instance rooms
    # when pressing confirm button for earlier date.
    old_room = room
    new_room = current_hotel.rooms.find_by_room_no(params[:room_number].strip) if params[:room_number]
    if new_room.present?
      room = new_room if old_room.room_no != new_room.room_no
    end

    Reservation.transaction do
      reservation.update_attributes!(arrival_date: new_arrival_date, dep_date: new_dep_date)

      (reservation.arrival_date..reservation.dep_date).each do |day|
        unless reservation.daily_instances.where(reservation_date: day).exists?
          reservation.daily_instances.create!(reservation_date: day, rate_id: rate.id, room: new_room, room_type_id: room_type.id,
                                              adults: adults, children: children,
                                              infants: infants, status: reservation.status, currency_code: current_hotel.default_currency,
                                              rate_amount: rate.calculate_rate_amount(day, room_type, adults, children))
        end
      end
      # Destroy all outlying daily instances
      reservation.daily_instances.outlying.destroy_all
      # Inventory management - Based on CICO-8604
      # Get new instance date from daily instances
      new_instance_dates = reservation.daily_instances.where('reservation_date != ?', new_dep_date).pluck(:reservation_date)
      # Get the list of inventories whose sold count is to be decreased
      remove_inventories = old_instance_dates - new_instance_dates
      # New departure date is to be excluded - So putting into the remove inventories array
      remove_inventories << new_dep_date
      # Get the inventory list whose sold count is to be increased
      add_inventories = new_instance_dates - old_instance_dates
      # Handle previous departure date when stay is extended
      add_inventories << old_dep_date if new_instance_dates.include?(old_dep_date)
      # Loop in remove inventories array
      remove_inventories.each do |remove_date|
        # Decrement sold count of inventory
        InventoryDetail.record!(rate.id, room_type.id, current_hotel.id, remove_date, false)
      end
      # Loop in add inventories array
      add_inventories.each do |add_date|
        # Skip iteration when date to be added is new departure date
        next if add_date == new_dep_date
        # Increment sold count of inventory
        InventoryDetail.record!(rate.id, room_type.id, current_hotel.id, add_date, true)
      end
      unassign_preassigned_reservations(reservation, new_arrival_date, new_dep_date, room)
    end

    { status: errors.empty? ? SUCCESS : FAILURE, data: nil, errors: errors }
  rescue ActiveRecord::RecordInvalid => e
    { status: FAILURE, data: nil, errors: [e.message] }
  end

  def unassign_preassigned_reservations(reservation, new_arrival_date, new_dep_date, room)
    preassigned_daily_instances = current_hotel.daily_instances.select('distinct reservation_id').where('reservation_id != ?', reservation.id)
      .where('reservation_date >= ? and reservation_date <= ?', new_arrival_date, new_dep_date).where(room_id: room.id)

    preassigned_daily_instances.each do |preassigned_daily_instance|
      preassigned_daily_instance.reservation.daily_instances.each { |preassigned_instance| preassigned_instance.update_attributes!(room: nil) }
    end
  end
end
