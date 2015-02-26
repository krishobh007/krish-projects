json.currency do
  json.call(current_hotel.default_currency, :id, :value, :symbol)
end

json.date_format do
  json.call(current_hotel.default_date_format, :id, :value) if current_hotel.default_date_format
end

json.pms_type do
  if current_hotel.pms_type
    json.call(current_hotel.pms_type, :id, :value)
  else
    json.null!
  end
end

json.language do
  if current_hotel.language
    json.call(current_hotel.language, :id, :value)
  else
    json.null!
  end
end

json.late_checkout_settings do
  json.is_late_checkout_on current_hotel.settings.late_checkout_is_on
end

json.upsell_settings do
  json.is_upsell_settings_on current_hotel.settings.upsell_is_on
end

json.housekeeping do
  json.checkin_inspected_only current_hotel.settings.checkin_inspected_only
  json.use_pickup current_hotel.settings.use_pickup
  json.use_inspected current_hotel.settings.use_inspected
  json.is_queue_rooms_on current_hotel.settings.is_queue_rooms_on
  json.enable_room_status_at_checkout current_hotel.settings.enable_room_status_at_checkout ||
                                        Setting.defaults[:enable_room_status_at_checkout]
  json.email  current_hotel.staff_alert_emails.queue_reservation_alerts.present? ? current_hotel.staff_alert_emails.queue_reservation_alerts.pluck(:email).join(';') : ''
end

json.icare do
  json.enabled current_hotel.settings.icare_enabled
  json.debit_charge_code_id current_hotel.settings.icare_debit_charge_code_id
  json.credit_charge_code_id current_hotel.settings.icare_credit_charge_code_id
end
json.current_user do
  json.id current_user.id
  json.name current_user.full_name
  json.email current_user.email
  json.roles current_user.roles.each do |role|
    json.id role.id
    json.name role.name
  end
  json.default_dashboard  current_user.default_dashboard.value
end

json.business_date do
  json.is_auto_change_bussiness_date  current_hotel.settings.is_auto_change_bussiness_date
  json.changing_hour current_hotel.settings.andand.business_date_change_time.andand.in_time_zone(current_hotel.tz_info).andand.strftime("%I")
  json.changing_minute current_hotel.settings.andand.business_date_change_time.andand.in_time_zone(current_hotel.tz_info).andand.strftime("%M")
  json.business_date_prime_time current_hotel.settings.andand.business_date_change_time.andand.in_time_zone(current_hotel.tz_info).andand.strftime("%p")
end

json.no_show_charge_code_id current_hotel.settings.no_show_charge_code_id.to_s

json.terms_and_conditions current_hotel.settings.terms_and_conditions

json.ar_number_settings do
  json.is_auto_assign_ar_numbers  current_hotel.settings.is_auto_assign_ar_numbers || Setting.defaults[:is_auto_assign_ar_numbers]
end

json.reservation_type do
  json.is_origin_of_booking_enabled current_hotel.settings.use_origins
  json.is_makets_enabled current_hotel.settings.use_markets
  json.is_source_enabled current_hotel.settings.use_sources
end
json.is_hourly_rate_on current_hotel.settings.is_hourly_rate_on

json.is_addon_on current_hotel.settings.is_addon_on

json.mli_merchant_id current_hotel.settings.mli_merchant_id

json.payment_gateway  payment_gateway(current_hotel)

json.is_allow_manual_cc_entry  current_hotel.settings.is_allow_manual_cc_entry.nil? ? ( current_hotel.is_third_party_pms_configured? ? Setting.defaults[:is_allow_manual_cc] : true ) : current_hotel.settings.is_allow_manual_cc_entry

json.is_single_digit_search current_hotel.settings.is_single_digit_search

json.hotel_time_zone_full current_hotel.tz_info
json.hotel_time_zone_abbr Time.now.in_time_zone(current_hotel.tz_info).zone