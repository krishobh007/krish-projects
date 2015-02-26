json.results @room_response do |room|
  json.date room[:date]
  json.availability room[:available_room_ids]
  
end  

