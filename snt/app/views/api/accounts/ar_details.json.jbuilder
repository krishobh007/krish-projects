json.is_use_main_contact @ar_detail.is_use_main_contact
json.is_use_main_address @ar_detail.is_use_main_address
json.ar_number @ar_detail.ar_number
json.is_auto_assign_ar_numbers current_hotel.settings.is_auto_assign_ar_numbers
json.ar_contact_details do
  json.contact_first_name @ar_detail.contact_first_name
  json.contact_last_name @ar_detail.contact_last_name
  json.phone @ar_detail.phone.andand.value
  json.email @ar_detail.email.andand.value
  json.job_title @ar_detail.job_title
end
json.ar_address_details do
  json.street1 @ar_detail.address.andand.street1
  json.street2 @ar_detail.address.andand.street2
  json.street3 @ar_detail.address.andand.street3
  json.city @ar_detail.address.andand.city
  json.state @ar_detail.address.andand.state
  json.postal_code @ar_detail.address.andand.postal_code
  json.country_id @ar_detail.address.andand.country_id
end
