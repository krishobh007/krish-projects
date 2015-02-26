class Api::HourlyAvailabilityController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  def index
    rate_id  = params[:rate_id].present? ? params[:rate_id]  : nil 
    # Configure rate as per the provided rate type
    if params[:rate_type] == "Standard"
      @rates  = rate_id ? Rate.where(id: rate_id) : current_hotel.rates.active.fully_configured.include_public_only.not_expired(params[:begin_date]).non_contract.where('is_hourly_rate = true').first
    elsif params[:rate_type] == "Corporate"
      account = Account.find(params[:account_id])
      @rates  = account.rates.where('is_hourly_rate = true').first if account
      unless @rates
        render(json: [I18n.t(:rate_not_found)], status: :unprocessable_entity)
        return
      end
      # As per CICO-9481, if linked contracte rate is not hourly, we should return failure error message.
      if @rates && @rates.based_on_rate.is_hourly_rate == false
        render(json: [I18n.t(:rate_is_not_hourly)], status: :unprocessable_entity)
        return
      end

    else
      @rates  = rate_id ? Rate.where(id: rate_id) : current_hotel.rates.active.fully_configured.include_public_only.not_expired(params[:begin_date]).non_contract.where('is_hourly_rate = true').first
    end

    @room_types = params[:room_type_id].present? ? current_hotel.room_types.is_not_pseudo.where(id: params[:room_type_id]) :
                  current_hotel.room_types.is_not_pseudo

    @rooms = current_hotel.rooms.where(room_type_id: @room_types.pluck(:id))

    @begin_date = params[:begin_date].present? ? params[:begin_date].to_date : current_hotel.active_business_date - 1.day

    @end_date = params[:end_date].present? ? params[:end_date].to_date :  @begin_date + 1.day

    @begin_time = getDatetime(@begin_date, params[:begin_time], current_hotel.tz_info).utc

    @end_time = getDatetime(@end_date, params[:end_time], current_hotel.tz_info).utc
    departure_time_hash = RoomAvailability.clean_departure_time_hash(@room_types)
    # CICO-13684: Logic to calculate maximum task time as 0 when there is no "Clean Departures" task associated with the room type.
    max_task_time = departure_time_hash.empty? ? Time.now.beginning_of_day : largest_value(departure_time_hash)
    begin_time_with_cleaning_time = @begin_time - (max_task_time.hour.hour + max_task_time.min.minute)
    end_time_with_cleaning_time = @end_time  + (max_task_time.hour.hour + max_task_time.min.minute)

    available_rooms = RoomAvailability.available_rooms(current_hotel, @room_types, @begin_time, @end_time, false)
    # As per CICO-11238- We need to send the Room with status for web booking reservations.
    @blocked_rooms = @rooms.pre_reservations_between(begin_time_with_cleaning_time, end_time_with_cleaning_time)
    booked_room_ids = []
    @blocked_rooms.each do |each_room|
      clean_time = departure_time_hash[each_room.room_type_id]
      new_begin_time = @begin_time - (clean_time.hour.hour + clean_time.min.minute)
      new_end_time = @end_time + (clean_time.hour.hour + clean_time.min.minute)
      is_blocked_room_overlapped_with_booked_reservations = each_room.reservation_daily_instances.joins(:reservation).where('arrival_time <= ?  and departure_time >= ?',new_end_time, new_begin_time).count > 0
      if is_blocked_room_overlapped_with_booked_reservations
        booked_room_ids << each_room.id
      end
    end
    @blocked_rooms = booked_room_ids.empty? ? @blocked_rooms : @blocked_rooms.where('rooms.id not in (?)', booked_room_ids)
    @room_response = construct_response(available_rooms + @blocked_rooms)
  end

  def availability_count
    @room_types = current_hotel.room_types.is_not_pseudo

    begin_date = params[:begin_date].to_date
    begin_time = params[:begin_time]
    end_date = params[:end_date].to_date
    end_time = params[:end_time]
    base_availability = {}
    begin_datetime = getDatetime(begin_date, begin_time, current_hotel.tz_info).utc
    end_datetime =  getDatetime(end_date, end_time, current_hotel.tz_info).utc # Datetime, UTC
    # Identify max task completion time from the given tasks

    max_task_time = largest_value(clean_departure_time_hash)
    if max_task_time
      begin_time_with_cleaning_time = begin_datetime - (max_task_time.hour.hour + max_task_time.min.minute)
      end_time_with_cleaning_time = end_datetime  + (max_task_time.hour.hour + max_task_time.min.minute)
    else
      begin_time_with_cleaning_time = begin_datetime
      end_time_with_cleaning_time = end_datetime
    end

    # Get the total rooms ids of the hotel removing pseudo and suite rooms.
    total_rooms_count = current_hotel.rooms.exclude_pseudo.count
    # Get current Booked Reservations
    reservations = current_hotel.daily_instances.where('departure_time >= ? and arrival_time <= ? ',
                   begin_time_with_cleaning_time, end_time_with_cleaning_time)
                   .where('reservations.status_id NOT IN (?,?)', Ref::ReservationStatus[:NOSHOW].id, Ref::ReservationStatus[:CANCELED].id)
                   .select('reservation_id, arrival_time, departure_time, room_type_id').uniq.to_a

    # Found the OO rooms and remove from the total rooms count.
    ooo_rooms_on_each_date = current_hotel.rooms.out_of_order_between(begin_date, end_date).group(:date).count
    (begin_date..end_date).to_a.each do |date|
      base_availability[date.to_date] = {}
      rooms_count = total_rooms_count
      rooms_count -= ooo_rooms_on_each_date[date.to_date] if ooo_rooms_on_each_date[date.to_date]
      base_availability[date.to_date] = rooms_count - reservations.count
      # my_time.minute = 0
      # my_time.second = 0
      # my_time.milliseconds =0  # Round of to hour
      @hours_availability = []

    end # Date iteration end.

    # Iterate begin_time to end_time and contruct a hash with contains base availablity
    # base_availabilty  = Total rooms - OO for a date.
    my_time = begin_datetime
    while my_time <= end_datetime
      @hours_availability << { time: my_time, availability: base_availability[my_time.to_date].to_i }
      my_time += 1.hour
    end
    # Iterate through booked reservations and if available slot found add one count to the availability.
    for reservation in reservations
      clean_time = clean_departure_time_hash[reservation.room_type_id] if clean_departure_time_hash

      # Cleaning time is considered for departure only.
      # Cleaning time required, if a reservation is created, is not considered.
      sub_arrival_time = reservation.arrival_time
      # We need to consider cleaning time of reservation.
      if clean_time
        add_departure_time = reservation.departure_time + (clean_time.hour.hour + clean_time.min.minute)
      else
        add_departure_time = reservation.departure_time
      end

      for item in @hours_availability

      # We need to find availability for a given time, exact time, not a timeslot
      # Just checking Total Rooms = how many available + How many booked for the given hour.
      # If we need to consider a 1hr slot, change below to 1.hour
        if ( (item[:time] + 0.hour) < sub_arrival_time ) || (item[:time] >= add_departure_time)
          item[:availability] += 1
        end
      end

    end
    for item in @hours_availability
      item[:hour] = item[:time].in_time_zone(current_hotel.tz_info).hour
    end



  end

  def room
    reservation_id  = params[:reservation_id]
    room_id = params[:room_id]
    rooms = current_hotel.rooms.where(id: room_id)
    room = rooms.first
    rate_id  = params[:rate_id].present? ? params[:rate_id]  : nil
    room_types = current_hotel.room_types.where(id: room.room_type_id)
    @is_available = false
    @message = []

    if params[:rate_type] == 'Standard'
      @rates  = rate_id ? Rate.where(id: rate_id) : current_hotel.rates.active.fully_configured.include_public_only.not_expired(params[:begin_date]).non_contract.where('is_hourly_rate = true').first
    elsif params[:rate_type] == 'Corporate'
      account = Account.find(params[:account_id])
      @rates  = account.rates.where('is_hourly_rate = true').first if account
      # As per CICO-9481, if linked contracte rate is not hourly, we should return failure error message.
      if @rates && @rates.based_on_rate.is_hourly_rate == false
        render(json: [I18n.t(:rate_is_not_hourly)], status: :unprocessable_entity)
        return
      end
      # As per CICO-12362, when a company card attached which is doesnot have contact rate created
      # We should consider as STANDARD RATE
      unless @rates
        @rates  = rate_id ? Rate.where(id: rate_id) : current_hotel.rates.active.fully_configured.include_public_only.not_expired(params[:begin_date]).non_contract.where('is_hourly_rate = true').first
        logger.debug "HourlyAvailability::room API Company card - #{params[:account_id]}, but no contracts attached"
      end

    end
    begin_date = params[:begin_date].present? ? params[:begin_date].to_date : current_hotel.active_business_date - 1.day

    end_date = params[:end_date].present? ? params[:end_date].to_date :  begin_date + 1.day

    begin_time = getDatetime(begin_date, params[:begin_time], current_hotel.tz_info).utc

    end_time = getDatetime(end_date, params[:end_time], current_hotel.tz_info).utc
    departure_time_hash = RoomAvailability.clean_departure_time_hash(room_types)

    clean_time = departure_time_hash[room.room_type_id]
    new_begin_time = begin_time - (clean_time.hour.hour + clean_time.min.minute)
    new_end_time = end_time + (clean_time.hour.hour + clean_time.min.minute)

    # Get the exisitng reservation information with rate amount
    old_reservation = current_hotel.reservations.find(reservation_id)

    if old_reservation.status != :NOSHOW || old_reservation.status != :CANCELED
      @old_rate_amount = old_reservation.current_daily_instance.rate_amount.to_f if old_reservation
      @old_room_id =  old_reservation.current_daily_instance.room_id if old_reservation
      @old_rate_id = old_reservation.current_daily_instance.rate_id if old_reservation
    end
    # Check availability for OO Rooms
    out_of_order_rooms = current_hotel.rooms.where(id: room.id).out_of_order_between(begin_date, end_date)
    # Check Availabilty for exisitng reservations.
    if out_of_order_rooms.count > 0
      logger.debug 'HourlyAvailability::room API --OOO Rooms found'
      @is_available = false
      @message << I18n.t(:ooo_room_found)
      return
    end
    existing_reservations = []
    existing_reservations = room.reservation_daily_instances.joins(:reservation).where('reservations.id not in (?)', reservation_id)
                                         .where('reservations.arrival_time < ? and reservations.departure_time > ?',
                                         new_end_time, new_begin_time).where('reservations.status_id NOT IN (?,?)',
                                         Ref::ReservationStatus[:NOSHOW].id, Ref::ReservationStatus[:CANCELED].id) if out_of_order_rooms.count == 0
    if existing_reservations.uniq.count > 0
      logger.debug "HourlyAvailability::room API -- Existing Reservatons found with Reservation Ids - #{existing_reservations.pluck(:id)}"
      @is_available = false
      @message << I18n.t(:already_room_booked)
      return
    end
    blocked_rooms = rooms.pre_reservations_between(new_begin_time, new_end_time)
    if blocked_rooms.count > 0
      logger.debug 'HourlyAvailability::room API --Blocked Rooms found'
      @message << I18n.t(:blocked_room_found)
      @is_available = false
      return
    end
    # CICO-12300 - When user drag into room type or date which has not valid entry
    # we should show error message and back to old state of the room.
    room_type = room.room_type
    available_room_type_date_array = @rates.room_rates.for_date_and_room_type(begin_date, room_type).joins(:hourly_room_rates)
    if available_room_type_date_array.empty?
      logger.debug "HourlyAvailability::room API --Room Type -#{room_type}/ #{begin_date} is not attched to given rate - #{@rates.id}"
      @is_available = false
      @message << I18n.t(:room_type_date_not_valid)
      return
    end
    @is_available = true
    @new_rate_amount = @rates.calculate_hourly_rate_amount(begin_date, room_type, begin_time, end_time)
  end

  # As per CICO-12418 - For hourly when reservation in edit mode, 
  # user can able to move the reservation into another day
  # with given room_id, rate_id, reservation_id, begin_datetime, end_datetime

  def room_move
    reservation_id  = params[:reservation_id]
    room_id = params[:room_id]
    rooms = current_hotel.rooms.where(id: room_id)
    room = rooms.first
    rate_id  = params[:rate_id].present? ? params[:rate_id]  : nil
    @room_types = params[:room_type_id].present? ? current_hotel.room_types.is_not_pseudo.where(id: params[:room_type_id]) :
                  current_hotel.room_types.is_not_pseudo
    @is_available = false
    @message = []

    if params[:rate_type] == 'Standard'
      @rates  = rate_id ? Rate.where(id: rate_id) : current_hotel.rates.active.fully_configured.include_public_only.not_expired(params[:begin_date]).non_contract.where('is_hourly_rate = true').first
    elsif params[:rate_type] == 'Corporate'
      account = Account.find(params[:account_id])
      @rates  = account.rates.where('is_hourly_rate = true').first if account
      # As per CICO-9481, if linked contracte rate is not hourly, we should return failure error message.
      if @rates && @rates.based_on_rate.is_hourly_rate == false
        render(json: [I18n.t(:rate_is_not_hourly)], status: :unprocessable_entity)
        return
      end
      # As per CICO-12362, when a company card attached which is doesnot have contact rate created
      # We should consider as STANDARD RATE
      unless @rates
        @rates  = rate_id ? Rate.where(id: rate_id) : current_hotel.rates.active.fully_configured.include_public_only.not_expired(params[:begin_date]).non_contract.where('is_hourly_rate = true').first
        logger.debug "HourlyAvailability::room API Company card - #{params[:account_id]}, but no contracts attached"
      end

    end
    begin_date = params[:begin_date].present? ? params[:begin_date].to_date : current_hotel.active_business_date - 1.day

    end_date = params[:end_date].present? ? params[:end_date].to_date :  begin_date + 1.day

    begin_time = getDatetime(begin_date, params[:begin_time], current_hotel.tz_info).utc

    end_time = getDatetime(end_date, params[:end_time], current_hotel.tz_info).utc

    room_type = room.room_type
    available_room_type_date_array = @rates.room_rates.for_date_and_room_type(begin_date, room_type).joins(:hourly_room_rates)
    if available_room_type_date_array.empty?
      @response_code = 'NOT_AVAILABLE'
      logger.debug "HourlyAvailability::room API --Room Type -#{room_type}/ #{begin_date} is not attched to given rate - #{@rates.id}"
      @response_messge =  I18n.t(:room_type_date_not_valid)
      return
    end

    # Get the exisitng reservation information with rate amount
    old_reservation = current_hotel.reservations.find(reservation_id)
    if old_reservation.status != :NOSHOW || old_reservation.status != :CANCELED
      @old_rate_amount = old_reservation.current_daily_instance.rate_amount.to_f if old_reservation
      @old_room_id =  old_reservation.current_daily_instance.room_id if old_reservation
      @old_rate_id = old_reservation.current_daily_instance.rate_id if old_reservation
    end


    # Check availability for OO Rooms
    room_no_room_type_same_array = []
    room_no_diff_room_type_same_array = []
    room_no_room_type_diff_array = []


    out_of_order_rooms = current_hotel.rooms.where(id: room.id).out_of_order_between(begin_date, end_date)

    departure_time_hash = RoomAvailability.clean_departure_time_hash(@room_types)
    clean_time = departure_time_hash[room.room_type_id]
    new_begin_time = begin_time - (clean_time.hour.hour + clean_time.min.minute)
    new_end_time = end_time + (clean_time.hour.hour + clean_time.min.minute)
    blocked_rooms = rooms.pre_reservations_between(new_begin_time, new_end_time)

    # Find the availabilty of the selected date range
    available_rooms = RoomAvailability.available_rooms(current_hotel, @room_types, begin_time, end_time, true, reservation_id)


    available_rooms.each do |each_room|
      room_room_type_hash = {}
      if each_room.id == room.id && each_room.room_type_id == room.room_type_id
        room_room_type_hash[:room_no] = each_room.room_no
        room_room_type_hash[:room_id] =  each_room.id
        room_room_type_hash[:room_type_id] =  each_room.room_type_id
        room_no_room_type_same_array << room_room_type_hash
      elsif each_room.id != room.id && each_room.room_type_id == room.room_type_id
        room_room_type_hash[:room_no] = each_room.room_no
        room_room_type_hash[:room_id] =  each_room.id
        room_room_type_hash[:room_type_id] =  each_room.room_type_id
        room_no_diff_room_type_same_array << room_room_type_hash
      else
        room_room_type_hash[:room_no] = each_room.room_no
        room_room_type_hash[:room_id] =  each_room.id
        room_room_type_hash[:room_type_id] =  each_room.room_type_id
        room_no_room_type_diff_array << room_room_type_hash
      end

    end

    # Set the response code and response message.
    # 1. If no room type is available, show message: 'No Availability for selected date' and do not move room
    # 2. If selected room number is not available, but same room type is available, move room into nearest available number of same room type.
    # 3. If selected room number is not available and same room type is not available
    #    but other room types are available, move booking to nearest available other room type. Room type change will be shown in rate pop up.

    if available_rooms.empty?
      @response_code = 'NOT_AVAILABLE'
      @response_messge = I18n.t(:room_not_available)

    # Category -01 Check for OOO rooms.
    # If found pass the response code along with response message.
    # return back the very next available room number & room id.
    elsif out_of_order_rooms.count > 0
      @response_code = 'OOO'
      @available_room_id = available_rooms.first.id
      @available_room_no = available_rooms.first.room_no

      @response_messge = I18n.t(:room_move_ooo_room_found, old_room_no: room.room_no, new_room_no: @available_room_no)
    # Category - 02 Check for Blocked rooms.
    # If found pass the response code along with response message.
    # return back the very next available room number & room id.
    elsif blocked_rooms.count > 0
      @response_code = 'BLOCKED'
      @available_room_id = available_rooms.first.id
      @available_room_no = available_rooms.first.room_no
      @response_messge = I18n.t(:room_move_blocking_room_found, old_room_no: room.room_no, new_room_no: @available_room_no)
    elsif !room_no_room_type_same_array.empty?
      @response_code = 'ROOM_ROOM_TYPE_AVAILABLE'
      @response_messge = I18n.t(:same_room_no_same_room_type)
      @available_room_id = room_no_room_type_same_array.first[:room_id]
      @available_room_no = room_no_room_type_same_array.first[:room_no]

    elsif !room_no_diff_room_type_same_array.empty?
      @response_code = 'ROOM_DIFF_ROOM_TYPE_AVAILABLE'
      @available_room_id = room_no_diff_room_type_same_array.first[:room_id]
      @available_room_no = room_no_diff_room_type_same_array.first[:room_no]
      @response_messge = I18n.t(:diff_room_no_same_room_type, old_room_no: room.room_no, new_room_no: @available_room_no)

    elsif !room_no_room_type_diff_array.empty?
      @response_code = 'ROOM_ROOM_TYPE_DIFF_AVAILABLE'
      @response_messge = I18n.t(:diff_room_no_diff_room_type)
      @available_room_id = room_no_room_type_diff_array.first[:room_id]
      @available_room_no = room_no_room_type_diff_array.first[:room_no]
      @response_messge = I18n.t(:diff_room_no_diff_room_type, old_room_no: room.room_no, new_room_no: @available_room_no)
    end

    logger.debug 'Condition -01 SAME ROOM NUMBER SAME ROOM TYPE'
    logger.debug room_no_room_type_same_array
    logger.debug '------------------------------'
    logger.debug 'Condition -02 DIFF ROOM NUMBER SAME ROOM TYPE'
    logger.debug room_no_diff_room_type_same_array
    logger.debug '------------------------------'
    logger.debug 'Condition -03 DIFF ROOM NUMBER DIFF ROOM TYPE'
    logger.debug room_no_room_type_diff_array

    @new_rate_amount = @rates.calculate_hourly_rate_amount(begin_date, room.room_type, begin_time, end_time)
  end

  private

  def availability_data(date_availability)
    result = {}
    date_availability.each do |each_date|
      date  = each_date[:date]
      result[date] = find_availability_non_zero_room_rate(each_date)
    end
    result
  end

  def find_availability_non_zero_room_rate(each_date)
    if  each_date[:rates].size > 0
      room_rates_array =  each_date[:rates][0][:room_rates]
      non_zero_room_rates(room_rates_array)
    else
      []
    end
  end

  def non_zero_room_rates(room_rates_array)
    availability_non_zero = []
    room_rates_array.each do | room_rate |
      availability_non_zero << room_rate if room_rate[:availability] > 0 && room_rate[:amount] > 0
    end
    availability_non_zero
  end

  # Find available rooms from the booked reservations
  # Calculating by - consider rooms which are not booked by reservation/ sold in given params.

  def construct_response(available_room_ids)
    room_array = []
    (@begin_date .. @end_date).each do |date|
      room_date = {}
      room_date[:date]  = date
      room_date[:available_room_ids] = construct_rooms_array_hash(available_room_ids)
      room_array << room_date
    end
    room_array
  end

  def construct_rooms_array_hash(available_rooms)
    @res = get_available_rates(available_rooms)
    rooms_array = []
    available_rooms.each do|room|
      selected_room_type =  @res[room.room_type_id]
      # The else condition is for just for logging where rate amount is zero ( ie, when rate is CLOSED)
      if selected_room_type && selected_room_type[:amount] > 0
        rooms_array <<
        {
          id: room.id,
          room_type_id: selected_room_type[:room_type_id],
          amount: selected_room_type[:amount],
          rate_id: selected_room_type[:rate_id],
          status: (@blocked_rooms.include? room) ? Setting.room_availablity[:web_booking] : Setting.room_availablity[:available]
        }
      end
    end
    rooms_array
  end

  def get_available_rates(available_room_ids)
    room_type_ids = available_room_ids.collect {|item| item.room_type_id }.uniq
    weekday = @begin_date.strftime('%A').downcase
    valid_rates = @rates.room_rates
                    .where('rate_date_ranges.begin_date <= :date and :date <= rate_date_ranges.end_date', date: @begin_date)
                    .where("rate_sets.#{weekday}")
                    .where('room_rates.room_type_id in (?)' , room_type_ids)
                    .select('rate_id , room_type_id')
    room_hash = []

    valid_rates.each do |rate_room_type|
      rate = Rate.find(rate_room_type.rate_id)
      room_type = RoomType.find(rate_room_type.room_type_id)
      amount = rate.calculate_hourly_rate_amount(@begin_date, room_type, @begin_time, @end_time)

      amount = amount > 0 ? amount : 0
      room_hash <<
      {
        rate_id: rate.id,
        amount: amount,
        room_type_id: room_type.id
      }
    end
    find_min_value(room_hash.group_by { |x| x[:room_type_id] })
  end

  def find_min_value(room_type_array_hash)
    resultant_hash = {}
    room_type_array_hash.each do |key, value|
      resultant_hash[key] = value.min { |a, b| a[:amount] <=> b[:amount] }
    end
    resultant_hash
  end

  def getDatetime(date, time, tz_info)
    ActiveSupport::TimeZone[tz_info].parse(date.to_s + ' ' + time.to_s)
  end

  def clean_departure_time_hash
    # selecting clean departure_time hash
    response_hash = {}
    @room_types.joins(:tasks).joins(:room_type_tasks).where("name = 'Clean Departures'").select('room_types.id as room_type_id, tasks.completion_time as tasks_completion_time, room_type_tasks.completion_time as room_types_completion_time').map { |each_task|
      response_hash[each_task.room_type_id] = each_task.room_types_completion_time ? each_task.room_types_completion_time : each_task.tasks_completion_time
    }
    response_hash
  end

  def largest_value(hash)
    hash && hash.max_by{|k,v| v}.last
  end

end


