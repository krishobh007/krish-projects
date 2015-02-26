json.recommended_rate_display @settings.use_recommended_rate_display
json.default_rate_display_name @settings.default_rate_display_name
json.is_addon_on @settings.is_addon_on
json.max_guests do
  json.max_adults @settings.reservation_max_adults.andand.to_i
  json.max_children @settings.reservation_max_children.andand.to_i
  json.max_infants @settings.reservation_max_infants.andand.to_i
end
json.is_hourly_rate_on  @settings.is_hourly_rate_on
json.disable_cc_swipe current_hotel.settings.disable_cc_swipe
json.disable_terms_conditions_checkin current_hotel.settings.disable_terms_conditions_checkin
json.disable_email_phone_dialog current_hotel.settings.disable_email_phone_dialog
json.disable_early_departure_penalty @settings.disable_early_departure_penalty == true ? true : false
json.disable_reservation_posting_control @settings.disable_reservation_posting_control == true ? true : false
