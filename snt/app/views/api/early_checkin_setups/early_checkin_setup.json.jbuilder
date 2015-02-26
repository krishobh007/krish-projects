json.is_early_checkin_allowed current_hotel.settings.is_allow_early_checkin || Setting.defaults[:is_allow_early_checkin]
json.early_checkin_charge_code current_hotel.settings.early_checkin_charge_code
json.number_of_early_checkins_per_day current_hotel.settings.max_number_of_early_checkins_per_day
json.hotel_currency current_hotel.default_currency.andand.symbol.to_s
json.early_checkin_time current_hotel.settings.early_checkin_time.to_s
json.early_checkin_levels @early_checkin_charges do |early_checkin_charge|
  json.id early_checkin_charge.id
  json.start_time early_checkin_charge.start_time.in_time_zone(current_hotel.tz_info).strftime("%H:%M %p")
  json.addon_id early_checkin_charge.addon_id
end
json.early_checkin_rates @early_checkin_rates do |early_checkin_rate|
  json.id early_checkin_rate.id
  json.name early_checkin_rate.rate_name
end
json.early_checkin_groups @early_checkin_groups do |early_checkin_group|
  json.id early_checkin_group.id
  json.name early_checkin_group.name
  json.start_date early_checkin_group.begin_date
  json.end_date early_checkin_group.end_date
end
