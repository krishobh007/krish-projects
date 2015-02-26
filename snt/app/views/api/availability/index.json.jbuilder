json.physical_count current_hotel.rooms.exclude_pseudo_and_suite.count

json.rates @rates do |rate|
  json.id rate.id
  json.name rate.rate_name
  json.description rate.rate_desc
  json.account_id rate.account_id
  # For CICO-6083 To handle SR for company card & normal Rate
  json.is_rate_shown_on_guest_bill rate.is_rate_shown_on_guest_bill
  json.is_suppress_rate_on rate.account_id? ? rate.is_rate_shown_on_guest_bill == false : rate.is_suppress_rate_on
  # for CICO-6079 To handle custom rate
  json.is_discount_allowed rate.is_discount_allowed_on

  json.rate_type do
  	json.id rate.rate_type.id
  	json.name rate.rate_type.name
  end

  deposit_policy  = rate.get_applicable_deposite_policy
  json.deposit_policy do
    json.id deposit_policy.andand.id
    json.name deposit_policy.andand.name
    json.description deposit_policy.andand.description
  end

  cancellation_policy = rate.cancellation_policy
  json.cancellation_policy do
    json.id cancellation_policy.andand.id
    json.name cancellation_policy.andand.name
    json.description cancellation_policy.andand.description
  end

  market_segment = rate.market_segment
  json.market_segment do
    json.id market_segment.andand.id
    json.name market_segment.andand.name
  end

  source = rate.source
  json.source do
    json.id source.andand.id
    json.name source.andand.code
  end
end

json.room_types @room_types do |room_type|
  json.id room_type.id
  json.name room_type.room_type_name
  json.physical_count @room_type_room_count[room_type.id] || 0
  json.max_occupancy room_type.max_occupancy
  json.description room_type.description
  json.level @upsell_room_levels.find { |room_level| room_level.room_type_id == room_type.id }.andand.level
end

json.tax_codes @tax_codes do |tax_code|
  json.id tax_code.id
  json.charge_code tax_code.charge_code
  json.description tax_code.description
  json.amount tax_code.amount
  json.amount_type tax_code.amount_type.to_s
  json.post_type tax_code.post_type.to_s
  if tax_code.amount_symbol == "amount"
    symbol = current_hotel.default_currency.symbol
  elsif tax_code.amount_symbol == "percent" || tax_code.amount_symbol == "%"
    symbol = "%"
  end
  json.amount_symbol symbol
  json.amount_sign (tax_code.amount && tax_code.amount >= 0) ? "+" : "-"
end

json.results @availability do |date_availability|
  json.date date_availability[:date].strftime('%Y-%m-%d')

  json.house do
    house = date_availability[:house]
    json.call(house, :sold, :sell_limit, :availability, :out_of_order)
  end

  json.room_types date_availability[:room_types].each do |room_type|
    json.call(room_type, :id, :sold, :sell_limit, :availability, :out_of_order)
  end

  json.rates date_availability[:rates].each do |rate|
    json.id rate[:id]
    tax_amounts = []
    if current_hotel.charge_codes.exists?(rate[:charge_code_id])
      charge_code = current_hotel.charge_codes.find(rate[:charge_code_id]) 
    end  
    if charge_code
      json.taxes charge_code.charge_code_generates.tax(current_hotel) do |charge_code_generate|
        json.charge_code_id charge_code_generate.generate_charge_code_id.to_s
        json.is_inclusive charge_code_generate.is_inclusive
        json.calculation_rules charge_code_generate.tax_calculation_rule_charge_codes.map {|x| x.id}
      end
    end

    json.room_rates rate[:room_rates] do |room_rate|
      json.call(room_rate, :room_type_id, :sold, :sell_limit, :availability)

      json.single room_rate[:single_amount]
      json.double room_rate[:double_amount]
      json.extra_adult room_rate[:extra_adult_amount]
      json.child room_rate[:child_amount]

      json.restrictions room_rate[:restrictions] do |restriction|
        json.call(restriction, :restriction_type_id, :days)
      end
    end
  end
end

json.total_count @dates.total_count
