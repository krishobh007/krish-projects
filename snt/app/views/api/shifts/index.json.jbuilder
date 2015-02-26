json.results @shifts do |shift|
  json.call(shift, :id, :name, :hotel_id, :is_system)
  json.time shift.time ? shift.time.andand.strftime("%H:%M") : "00:00"
end

json.total_count @shifts.total_count