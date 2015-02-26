json.booking_origins @booking_origins do |origin|
  json.value origin.id
  json.name origin.code
  json.description origin.description
  json.is_active origin.is_active
end
json.is_use_origins @is_use_origins