json.begin_date @date_range.begin_date
json.end_date @date_range.end_date
json.sets @date_range.sets.sorted do |set|
  json.id set.id
  json.name set.name
  json.sunday set.sunday
  json.monday set.monday
  json.tuesday set.tuesday
  json.wednesday set.wednesday
  json.thursday set.thursday
  json.friday set.friday
  json.saturday set.saturday
  json.day_min_hours set.day_min_hours
  json.day_max_hours set.day_max_hours
  json.day_checkout_cutoff_time set.day_checkout_cut_off_time ? set.day_checkout_cut_off_time.in_time_zone(@hotel.tz_info).andand.strftime("%H:%M") : nil
  json.night_checkout_cut_off_time set.night_checkout_cut_off_time ? set.night_checkout_cut_off_time.in_time_zone(@hotel.tz_info).andand.strftime("%H:%M") : nil
  json.night_start_time set.night_start_time ? set.night_start_time.in_time_zone(@hotel.tz_info).andand.strftime("%H:%M") : nil
  json.night_end_time set.night_end_time ? set.night_end_time.andand.in_time_zone(@hotel.tz_info).andand.strftime("%H:%M") : nil
  json.room_rates set.room_rates do |room_rate|
    json.id room_rate.room_type.id
    json.name room_rate.room_type.room_type_name
    json.single room_rate.single_amount
    json.double room_rate.double_amount
    json.extra_adult room_rate.extra_adult_amount
    json.child room_rate.child_amount
    json.nightly_rate room_rate.single_amount
    json.day_per_hour room_rate.day_hourly_incr_amount
    json.night_per_hour room_rate.night_hourly_incr_amount
    json.hourly_rates room_rate.andand.hourly_room_rates do |hourly_room_rate|
      json.hour hourly_room_rate.andand.hour ? DateTime.parse('%2d:00' % hourly_room_rate.andand.hour.to_i).in_time_zone(@hotel.tz_info).hour : nil
      json.amount hourly_room_rate.andand.amount.to_s
    end
  end
end
