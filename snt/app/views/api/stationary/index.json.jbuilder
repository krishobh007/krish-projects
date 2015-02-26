guest_bill_template = [
        {
            "value" => 1, "name" => "Default Guest Bill"
        }]
json.guest_bill_template guest_bill_template
json.hotel_logo @hotel_logo_types.each do |key, value|
  json.value value
  json.name (value != "NO_LOGO") ? "Use Hotel Logo Image for #{key.to_s.camelize}" : "No Logo"
end
if @guest_bill_print_setting
  json.show_hotel_address @guest_bill_print_setting.show_hotel_address
  json.custom_text_header @guest_bill_print_setting.custom_text_header
  json.custom_text_footer @guest_bill_print_setting.custom_text_footer
  # This is hard coded now since there are no other options
  json.selected_guest_bill_template 1
  json.logo_type @guest_bill_print_setting.logo_type
  json.location_image @location_image
end
json.confirmation_template_text @confirmation_template_text

json.cancellation_communication_title current_hotel.settings.cancellation_communication_title
json.cancellation_communication_text  current_hotel.settings.cancellation_communication_text
