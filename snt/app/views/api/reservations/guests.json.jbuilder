json.guests @guests do |guest|
  json.id guest.id
  json.guest_name abbreviated_name(guest.first_name, guest.last_name)
end