json.results @work_types.each do |work_type|
  json.call(work_type, :id, :name)
  json.unassigned @unassigned_rooms.each do |room|
    room_data = get_reservation(room, @date, @is_business_date)
    json.call(room_data, :id, :room_no, :current_status, :checkin_time, :checkout_time,
              :room_type, :is_vip, :floor_number, :is_queued, :reservation_status, :fo_status)
    json.time_allocated get_time_allocated(@date, room, work_type)
  end
end