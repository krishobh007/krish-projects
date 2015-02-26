json.results @guest_details do |guest_detail|
  json.id guest_detail.id
  json.first_name guest_detail.first_name
  json.last_name guest_detail.last_name
  json.image_url guest_detail.avatar.url
  primary_guest_address =  guest_detail.addresses.primary.first
  json.email guest_detail.email
  json.vip guest_detail.is_vip

  json.address do
    json.city primary_guest_address.andand.city
    json.state primary_guest_address.andand.state
    json.postal_code primary_guest_address.andand.postal_code
  end

  json.home_phone guest_detail.phones.home.pluck(:value).first

  reservations = guest_detail.reservations.where(hotel_id: current_hotel.id).with_status(:CHECKEDOUT).order('dep_date desc')
  current_daily_instance = reservations.first.andand.current_daily_instance
  json.last_stay do
    json.room_type current_daily_instance.andand.room_type.andand.room_type_name
    json.room current_daily_instance.andand.room.andand.room_no
    json.date current_daily_instance.andand.reservation_date
  end

  json.stay_count reservations.andand.count
end

json.total_count @guest_details.total_count
