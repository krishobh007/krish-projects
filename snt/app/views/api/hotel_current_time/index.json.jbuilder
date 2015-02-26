json.hotel_time do
  json.date @current_hotel_business_time.to_date
  json.hh @current_hotel_business_time.strftime("%H")
  json.mm @current_hotel_business_time.strftime("%M")
end