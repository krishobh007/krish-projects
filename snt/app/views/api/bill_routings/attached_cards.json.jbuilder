json.primary_guest_details do 
  if @reservation.primary_guest.present?
    json.id @reservation.primary_guest.id
    json.name @reservation.primary_guest.full_name
    json.avatar @reservation.primary_guest.avatar(:thumb)
  end
end

json.accompanying_guest_details @reservation.accompanying_guests do |accompanying_guest|
   json.id accompanying_guest.id
   json.name accompanying_guest.full_name
   json.avatar accompanying_guest.avatar(:thumb)
   json.primary_avatar @reservation.primary_guest.andand.avatar(:thumb)
end

json.travel_agent do
  json.id @reservation.travel_agent.id
  json.name @reservation.travel_agent.account_name
  json.logo @reservation.travel_agent.logo.andand.image(:thumb)
end if @reservation.travel_agent.present?

json.company_card do
  json.id @reservation.company.id
  json.name @reservation.company.account_name
  json.logo @reservation.company.logo.andand.image(:thumb)
end if @reservation.company.present?






