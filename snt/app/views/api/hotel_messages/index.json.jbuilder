json.results @hotel_messages do |hotel_message|
  json.id hotel_message.id
  json.message hotel_message.message
  json.key hotel_message.hotel_message_key.value
end