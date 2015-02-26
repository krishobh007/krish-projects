json.name rate.rate_name
json.description rate.rate_desc
json.code rate.rate_code
json.promotion_code rate.promotion_code
json.charge_code_id rate.charge_code_id
json.is_hourly_rate rate.is_hourly_rate

charge_code = rate.charge_code
charge_code_generates = charge_code.andand.charge_code_generates.tax(current_hotel)
if charge_code_generates
  if charge_code_generates.exists?(is_inclusive: false) && charge_code_generates.exists?(is_inclusive: true)
	inclusive_or_exclusive = "Multiple"
  elsif charge_code_generates.exists?(is_inclusive: false)
    inclusive_or_exclusive = "Exclusive"
  elsif charge_code_generates.exists?(is_inclusive: true)
    inclusive_or_exclusive = "Inclusive"
  else 
    inclusive_or_exclusive = nil
  end
end	
json.tax_inclusive_or_exclusive inclusive_or_exclusive 
json.currency_code_id rate.currency_code_id
json.end_date rate.end_date
json.source_id rate.source_id
json.market_segment_id rate.market_segment_id
json.is_commission_on rate.is_commission_on
json.is_suppress_rate_on rate.is_suppress_rate_on
json.is_discount_allowed_on rate.is_discount_allowed_on

deposit_policy_id = rate.get_applicable_deposite_policy.andand.id
json.deposit_policy_id deposit_policy_id

if deposit_policy_id
  deposit_policy = rate.get_applicable_deposite_policy
  json.deposit_policy do
    json.id deposit_policy.id
    json.name deposit_policy.name
    json.description deposit_policy.description
  end
end
json.cancellation_policy_id rate.cancellation_policy_id

json.min_advanced_booking rate.min_advanced_booking
json.max_advanced_booking rate.max_advanced_booking
json.min_stay rate.min_stay_length
json.max_stay rate.max_stay_length

json.use_rate_levels rate.use_rate_levels

json.based_on do
  based_on_rate = rate.based_on_rate

  if based_on_rate
    json.id based_on_rate.id
    json.name based_on_rate.rate_name
    json.type rate.based_on_type
    json.value rate.based_on_value
  else
    json.null!
  end
end

json.rate_type do
  rate_type = rate.rate_type

  if rate_type
    json.id rate_type.id
    json.name rate_type.name
  else
    json.null!
  end
end

json.date_range_count rate.date_ranges.count

json.status rate.is_active

json.room_types rate.room_types do |room_type|
  json.id room_type.id
  json.name room_type.room_type_name
end
json.addons @rate.rates_addons do |rate_addon|
  json.id rate_addon.addon.andand.id
  json.name rate_addon.addon.andand.name
  json.is_inclusive_in_rate rate_addon.is_inclusive_in_rate
end

json.date_ranges rate.date_ranges do |date_range|
  json.id date_range.id
  json.begin_date date_range.begin_date
  json.end_date date_range.end_date
  json.sets date_range.sets.sorted do |set|
    json.id set.id
    json.name set.name
    json.sunday set.sunday
    json.monday set.monday
    json.tuesday set.tuesday
    json.wednesday set.wednesday
    json.thursday set.thursday
    json.friday set.friday
    json.saturday set.saturday
    json.room_rates set.room_rates do |room_rate|
      room_type = room_rate.room_type

      json.id room_type.id
      json.name room_type.room_type_name
      json.single room_rate.single_amount
      json.double room_rate.double_amount
      json.extra_adult room_rate.extra_adult_amount
      json.child room_rate.child_amount
    end
  end
end
