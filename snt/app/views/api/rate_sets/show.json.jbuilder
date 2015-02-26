json.name @set.name
json.sunday @set.sunday
json.monday @set.monday
json.tuesday @set.tuesday
json.wednesday @set.wednesday
json.thursday @set.thursday
json.friday @set.friday
json.saturday @set.saturday

json.room_rates @set.room_rates do |room_rate|
  json.name room_rate.room_type.room_type_name
  json.single room_rate.single_amount
  json.double room_rate.double_amount
  json.extra_adult room_rate.extra_adult_amount
  json.child room_rate.child_amount
  json.nightly_rate room_rate.single_amount 
  json.day_per_hour room_rate.day_hourly_increment_amount
  json.night_per_hour room_rate.night_hourly_increment_amount
end
