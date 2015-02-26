json.results @room_types do |room_type|
  json.id room_type.id
  json.name room_type.room_type_name
  json.description room_type.description
  json.code room_type.room_type
  json.max_occupancy room_type.max_occupancy
end

json.total_count @room_types.total_count
