json.rooms @rooms.each do |room|
  json.id room.id.to_s
  json.room_type_id room.room_type_id.to_s
  json.room_no room.room_no
  json.room_type_name room.room_type.andand.room_type_name
  json.hk_status room.hk_status.to_s
  json.room_service_status Ref::ServiceStatus[room.service_status].to_s
end