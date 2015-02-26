class SearchController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  

  def search_view
    type = params[:type] ? params[:type] : ''
    business_date = current_hotel.active_business_date
    @is_late_checkout_on = current_hotel.settings.late_checkout_is_on
    @late_checkout_count = current_hotel.reservations.is_late_checkout(business_date).count if @is_late_checkout_on
    @is_queue_rooms_on = current_hotel.settings.is_queue_rooms_on
    @queued_rooms_count = current_hotel.reservations.queued(business_date).count if @is_queue_rooms_on
    render layout: false, locals: { data: { 'type' => type } }
  end

  def search
    results = []
    messages = []
    error = false
    start_time = Time.now
    query = params[:query]
    status = params[:status]
    is_vip = params[:vip]
    hotel_code = params[:hotel_code]
    request_date_string = params[:request_date]
    is_late_checkout_only = params[:is_late_checkout_only]
    is_queued_rooms_only = params[:is_queued_rooms_only]
    from_date = params[:from_date]
    to_date   = params[:to_date]
    room_search = params[:room_search]
    
    hotel = hotel_code ? Hotel.find_by_code(hotel_code) : current_hotel
    @hotel = hotel
    @avatar_trans_url = request.protocol + request.host_with_port + '/assets/avatar-trans.png'
    if request_date_string
      # Parse the request date param
      request_date = DateTime.parse(request_date_string) if request_date_string
    elsif hotel
      # Get the hotel's current business date
      request_date = hotel.active_business_date
    end

    messages = validate_request(status, hotel, request_date_string, request_date)
    error = messages.present?

    if !error
      # Search reservations and build reset hash for each reservation
      @data = construct_results(query, status, hotel, request_date, from_date, to_date, is_late_checkout_only, is_queued_rooms_only, is_vip, params[:page], params[:per_page], room_search)

      duration = Time.now - start_time
      logger.info "Search ActiveRecord - Duration: #{duration}, Per Reservation: #{duration / results.count}"
      # render json: { status: SUCCESS, data: results, errors: nil }
    else
      logger.debug 'Search API request invalid: ' + messages.to_s
      render json: { status: FAILURE, data: nil, errors: messages }
    end
    duration = Time.now - start_time
    logger.info "Search ActiveRecord - After Render JSON ----- Duration: #{duration}"

  end

  private

  # Validate the request parameters and return error messages
  def validate_request(status, hotel, request_date_string, request_date)
    messages = []

    # Validate that the reservation status exists
    messages << "Reservation status with value '#{status}' does not exist." if status && !Setting.reservation_input_status.value?(status)

    # Validate that a hotel was found
    messages << "Hotel with code '#{hotel_code}' does not exist." unless hotel

    # Validate that the request date could be converted
    messages << "Request date '#{request_date_string}' could not be parsed." if request_date_string && !request_date

    messages
  end

  # Find the reservations in the database using the search parameters
  def find_reservations(query, status, hotel, request_date, from_date, to_date, is_late_checkout_only, is_queued_rooms_only, is_vip = false, room_search)
    active_business_date = hotel.active_business_date

    reserved_status_id = Ref::ReservationStatus[:RESERVED].id
    inhouse_id = Ref::ReservationStatus[:CHECKEDIN].id
    checked_out_id = Ref::ReservationStatus[:CHECKEDOUT].id
    
    date_filter_query = true
    if !(to_date.blank? || from_date.blank?)
      date_filter_query = "(reservations.arrival_date <= '#{to_date}' AND reservations.arrival_date >= '#{from_date}') OR "\
               "(reservations.dep_date <= '#{to_date}' AND reservations.dep_date >= '#{from_date}') OR "\
               "(reservations.arrival_date <= '#{from_date}' AND reservations.dep_date >= '#{to_date}')"
    elsif to_date.blank? && from_date.present?
      date_filter_query = "(reservations.arrival_date >= '#{from_date}') OR "\
               "(reservations.dep_date >= '#{from_date}')"
    else
      date_filter_query = "reservations.dep_date >= '#{active_business_date - 7.days}'"
    end

    order_query = 'reservations.id'
    business_date = current_hotel.active_business_date

    # Ordered the logic while working for CICO-12451.
    is_hourly_rate_enabled_for_hotel = current_hotel.settings.is_hourly_rate_on
    if is_hourly_rate_enabled_for_hotel
      if status.present? 
        if status == Setting.reservation_input_status[:due_in]
          # Order Arrivals by Arrival time/date, then alphabetically, then by room number. Reservations without arrival time should be displayed last.
          order_query = 'reservations.arrival_time', 'reservations.arrival_date','guest_details.last_name',  'guest_details.first_name', 'rooms.room_no'
        elsif status == Setting.reservation_input_status[:due_out]
          # Order Departures by Departure time, then alphabetically, then by room number Reservations without departure time should be displayed last
          order_query = 'reservations.departure_time', 'reservations.dep_date','guest_details.last_name', 'guest_details.first_name',  'rooms.room_no' 
        end
      end
      if query.present?
        # Check if query is a number
        if /\A[-+]?\d+\z/ === query 
          due_out_cut_off_time = (ViewMappings::StayCardMapping.getDatetime(business_date, Time.now.utc, current_hotel) + 1.hour).utc
          order_query = "CASE WHEN (reservations.dep_date >= '#{business_date}' AND reservations.departure_time > '#{due_out_cut_off_time}' AND reservations.status_id = #{Ref::ReservationStatus[:CHECKEDIN].id}) THEN 0 
          WHEN (reservations.dep_date >= '#{business_date}' AND reservations.departure_time <= '#{due_out_cut_off_time}' AND reservations.status_id = #{Ref::ReservationStatus[:CHECKEDIN].id}) THEN 1 
          WHEN (reservations.status_id = #{Ref::ReservationStatus[:RESERVED].id}) THEN 2
          WHEN (reservations.status_id = #{Ref::ReservationStatus[:CHECKEDOUT].id}) THEN 3
          WHEN (reservations.status_id = #{Ref::ReservationStatus[:NOSHOW].id}) THEN 4
          ELSE 5 END, reservations.id"
        else 
          order_query = 'guest_details.first_name', 'guest_details.last_name', 'reservations.arrival_date', 'reservations.dep_date ASC' 
        end
      end
    else
      if query.present?
        # Check if query is a number
        if /\A[-+]?\d+\z/ === query 
          order_query = "CASE WHEN (reservations.dep_date > '#{business_date}' AND reservations.status_id = #{Ref::ReservationStatus[:CHECKEDIN].id}) THEN 0 
          WHEN (reservations.dep_date = '#{business_date}' AND reservations.status_id = #{Ref::ReservationStatus[:CHECKEDIN].id}) THEN 1 
          WHEN (reservations.status_id = #{Ref::ReservationStatus[:RESERVED].id}) THEN 2 
          WHEN (reservations.status_id = #{Ref::ReservationStatus[:CHECKEDOUT].id}) THEN 3
          WHEN (reservations.status_id = #{Ref::ReservationStatus[:NOSHOW].id}) THEN 4
          ELSE 5 END, reservations.id"
        else
          order_query = 'guest_details.first_name', 'guest_details.last_name', 'reservations.arrival_date', 'reservations.dep_date ASC'
        end
      end
    end

    reservations = Reservation.joins(:daily_instances)
      .joins('LEFT OUTER JOIN reservations_guest_details ON reservations_guest_details.reservation_id = reservations.id')
      .joins('LEFT OUTER JOIN guest_details ON guest_details.id = reservations_guest_details.guest_detail_id')
      .joins('LEFT OUTER JOIN groups ON reservation_daily_instances.group_id = groups.id')
      .joins('LEFT OUTER JOIN rooms ON reservation_daily_instances.room_id = rooms.id')
      .joins('LEFT OUTER JOIN accounts AS travel_agent_accounts ON travel_agent_accounts.id = reservations.travel_agent_id')
      .joins('LEFT OUTER JOIN accounts AS company_accounts ON company_accounts.id = reservations.company_id')
      .select("reservations.id, reservations.hotel_id, arrival_date, dep_date, confirm_no, TIMESTAMP(reservations.arrival_time) as arrival_time, reservations.status_id, is_queued, is_pre_checkin, "\
             "name group_name, is_occupied, guest_details.id as guest_detail_id, reservation_date, is_opted_late_checkout, "\
             "late_checkout_time, reservations_guest_details.is_primary as is_primary_guest, guest_details.first_name, guest_details.last_name, guest_details.is_vip, "\
             "rooms.room_no, rooms.is_occupied, rooms.id as room_id, rooms.hk_status_id,is_hourly, departure_time, "\
             "company_accounts.account_name as company_account_name, travel_agent_accounts.account_name as travel_agent_account_name, arrival_date, dep_date, arrival_time, departure_time")
      .search_by_hotel(query, status, hotel, request_date, is_late_checkout_only, is_queued_rooms_only, is_vip, false, room_search, is_hourly_rate_enabled_for_hotel)
      .where(date_filter_query)
      .order(order_query)
    reservations
  end

  # Find all the guest details that are associated with the reservations and put them in a hash
  def find_guest_details_hash(guest_detail_ids)
    guest_details = GuestDetail.where(id: guest_detail_ids).select('id, title, avatar_file_name, avatar_updated_at, hotel_chain_id')
    Hash[guest_details.map { |guest_detail| [guest_detail.id, guest_detail] }]
  end

   # Find all the guest details that are associated with the reservations and put them in a hash
  def find_addresses_hash(guest_detail_ids)
    addresses = Address.where(associated_address_id: guest_detail_ids, associated_address_type: 'GuestDetail').select('associated_address_id, city, state')
    Hash[addresses.map { |address| [address.associated_address_id, address] }]
  end

  # Find all the rooms that are associated with the reservations and put them in a hash
  def find_rooms_hash(room_ids, active_business_date)
    rooms = Room.joins(reservation_daily_instances: :reservation)
      .where('rooms.id IN (?) AND reservation_daily_instances.reservation_date = ?', room_ids, active_business_date)
      .select('rooms.id, rooms.hotel_id, reservations.status_id as reservation_status_id, rooms.hk_status_id, reservations.dep_date, '\
              'rooms.is_occupied')

    # Rooms hash needs checked_in status first. If no reservation there is no multiple reservation on same room take only the current one
    rooms_hash = {}
    rooms.each do |room|
      if !rooms_hash[room.id].present? || Ref::ReservationStatus[room.reservation_status_id] === :CHECKEDIN
        rooms_hash[room.id] = room
      end
    end
    rooms_hash
  end

  # Construct the results hash array using the search results
  def construct_results(query, status, hotel, request_date, from_date, to_date, is_late_checkout_only, is_queued_rooms_only, is_vip = false, page ,per_page, room_search)
    active_business_date = hotel.active_business_date
    reservations = find_reservations(query, status, hotel, request_date, from_date, to_date, is_late_checkout_only, is_queued_rooms_only, is_vip, room_search)
    resultant_ids = reservations.map { |result| { room_id: result.room_id, guest_detail_id: result.guest_detail_id } }
    guest_detail_ids = resultant_ids.map { |x| x[:guest_detail_id] }
    room_ids = resultant_ids.map { |x| x[:room_id] }
    guest_details_hash = find_guest_details_hash(guest_detail_ids.uniq)
    rooms_hash = find_rooms_hash(room_ids.uniq, active_business_date)
    address_hash = find_addresses_hash(guest_detail_ids.uniq)
    hk_statuses = Ref::HousekeepingStatus.all.as_json
    occupied_status = Ref::FrontOfficeStatus[:OCCUPIED].value
    vacant_status =  Ref::FrontOfficeStatus[:VACANT].value
    total_count =reservations.count
    reservations = reservations.to_a
    page = params[:page].to_i
    per_page = params[:per_page].to_i
    a = (page-1)*per_page;
    b = per_page;
    reservations = reservations.slice(a,b)
    data = {
      reservations: reservations,
      guest_details_hash: guest_details_hash,
      rooms_hash: rooms_hash,
      address_hash: address_hash,
      hk_statuses: hk_statuses,
      occupied_status: occupied_status,
      vacant_status: vacant_status,
      total_count: total_count
    }
    data
  end

  # Determines if the room is due out based on the reservations status
  def due_out?(room, active_business_date)
    room.dep_date == active_business_date && Ref::ReservationStatus[room.reservation_status_id] === :CHECKEDIN
  end

  def calculated_ready_status(hk_status_id, is_occupied, is_inspected_only, hk_statuses)
    status = hk_statuses.as_json.find { |h| h['id'] == hk_status_id }['value']
    if is_inspected_only
      (status == 'INSPECTED') && (!is_occupied)
    else
      (status == 'INSPECTED' || status == 'CLEAN') && (!is_occupied)
    end
  end

    # Return this value for managing UI
  def mapped_fo_status(due_out = is_due_out?,  is_occupied, occupied_status, vacant_status)
    if due_out
      Setting.room_fo_status[:dueout]
    else
      is_occupied ? occupied_status : vacant_status
    end
  end
end
