json.adult_count          @current_daily_instance.andand.adults
json.children_count       @current_daily_instance.andand.children
json.infants_count        @current_daily_instance.andand.infants
json.varying_occupancy    false

json.primary_guest_details do
  json.first_name @reservation.primary_guest.andand.first_name
  json.last_name  @reservation.primary_guest.andand.last_name
  json.is_vip     @reservation.primary_guest.andand.is_vip
  json.image      @reservation.primary_guest.andand.avatar.andand.url(:thumb)
end

accompanying_guests = @reservation.accompanying_guests
if accompanying_guests.size < 3
  additional_entries = 3 - accompanying_guests.size
  for i in (0...additional_entries)
    accompanying_guests << nil
  end
end

json.accompanying_guests_details accompanying_guests.each do |accompanying_guest|
  json.first_name accompanying_guest.andand.first_name
  json.last_name  accompanying_guest.andand.last_name
  json.image      accompanying_guest.nil? ? GuestDetail.new.avatar.url(:thumb) : accompanying_guest.andand.avatar.andand.url(:thumb) 
  json.id         accompanying_guest.andand.id
end
