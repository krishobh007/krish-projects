class RoomAvailability
  # Find available rooms from the booked reservations
  # Calculating by - consider rooms which are not booked by reservation/ sold in given params.
  def self.available_rooms(current_hotel, room_types, from_time, to_time, exclude_locked_rooms, reservation_id = nil)
    rooms = current_hotel.rooms.where(room_type_id: room_types.pluck(:id))
    begin_date = from_time.in_time_zone(current_hotel.tz_info).to_date
    end_date = to_time.in_time_zone(current_hotel.tz_info).to_date
    # Collect all OO rooms from the list
    out_of_order_room_ids = rooms.out_of_order_between(begin_date, end_date).pluck(:room_id)
    # Collect all Pre Booking Reservation from the list.
    pre_reservation_room_ids = rooms.pre_reservations_between(from_time, to_time).pluck(:room_id)
    # exclude_locked_rooms = false: locked rooms should be included for hourly_availability#index
    # exclude_locked_rooms = true: locked rooms should be excluded for papi_booking_controller#fetch_hourly_availability
    total_ignorable_room_ids = exclude_locked_rooms ? (out_of_order_room_ids + pre_reservation_room_ids) : out_of_order_room_ids
    available_room_ids = rooms.pluck(:id) - total_ignorable_room_ids
    clean_departure_time_hash = clean_departure_time_hash(room_types)
    # CICO-13684: Logic to calculate maximum task time as 0 when there is no "Clean Departures" task associated with the room type.
    max_task_time = clean_departure_time_hash.empty? ? Time.now.beginning_of_day : largest_value(clean_departure_time_hash)
    begin_time_with_cleaning_time = from_time - (max_task_time.hour.hour + max_task_time.min.minute)
    end_time_with_cleaning_time = to_time  + (max_task_time.hour.hour + max_task_time.min.minute)
    # As per CICO-12418, exclude the current reservation from availability
    if reservation_id
      current_hotel_reservations = current_hotel.reservations.where('reservations.id not in (?)', reservation_id)
    else
      current_hotel_reservations = current_hotel.reservations
    end
    reservation_ids = current_hotel_reservations.where('departure_time > ? and arrival_time <  ?', begin_time_with_cleaning_time, end_time_with_cleaning_time)
                      .exclude_status(:CANCELED, :NOSHOW).pluck(:id)

    booked_reservations = current_hotel.daily_instances
                          .where(reservation_id: reservation_ids)
                          .select('reservation_id, room_id, room_type_id, arrival_time, departure_time').as_json

    for reservation in booked_reservations
      clean_time = clean_departure_time_hash[reservation['room_type_id']]
      if clean_time
        add_begin_time = from_time - (clean_time.hour.hour + clean_time.min.minute)
        sub_end_time  = to_time + (clean_time.hour.hour + clean_time.min.minute)
        if reservation['departure_time'] > add_begin_time && reservation['arrival_time'] < sub_end_time
          available_room_ids.delete(reservation['room_id']) unless reservation['room_id'].nil?
        end
      end  
    end
    # TODO Need optimze query

    available_room_details = rooms.where(id: available_room_ids)
    available_room_details
  end

  def self.clean_departure_time_hash(room_types)
    # selecting clean departure_time hash
    response_hash = {}
    room_types.joins(:tasks).joins(:room_type_tasks).where("name = 'Clean Departures'").select('room_types.id as room_type_id, room_type_tasks.completion_time as room_type_completion_time, tasks.completion_time as task_completion_time').map { |each_task|
      
      room_type_completion_time = each_task.room_type_completion_time
      task_completion_time = each_task.task_completion_time
      response_hash[each_task.room_type_id] = room_type_completion_time ? room_type_completion_time : task_completion_time     }
    
    response_hash
  end

  def self.largest_value(hash)
    hash.max_by{|k,v| v}.last
  end
end
