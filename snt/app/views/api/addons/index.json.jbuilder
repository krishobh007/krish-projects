json.bestseller current_hotel.settings.addon_is_bestseller

json.results @addons do |addon|
  json.call(addon, :id, :name, :description, :amount, :bestseller)
  json.activated addon.is_active

  charge_group = addon.charge_group
  if charge_group
    json.charge_group do
      json.id charge_group.id
      json.name charge_group.charge_group
    end
  else
    json.charge_group {}
  end

  post_type = addon.post_type
  if post_type
    json.post_type do
      json.id post_type.id
      json.value post_type.value
      json.description post_type.description
    end
  else
    json.post_type {}
  end

  amount_type = addon.amount_type
  if amount_type
    json.amount_type do
      json.id amount_type.id
      json.value amount_type.value
      json.description amount_type.description
    end
  else
    json.amount_type {}
  end

  charge_code = addon.charge_code
  if charge_code
    tax_amounts = []
    if charge_code.is_tax?
      json.taxes do
        json.id charge_code.id
        json.charge_code charge_code.charge_code
        json.description charge_code.description
        json.amount charge_code.amount
        json.amount_type charge_code.amount_type.to_s
        json.post_type charge_code.post_type.to_s
        json.amount_symbol charge_code.amount_symbol
        json.amount_sign (charge_code.amount && charge_code.amount >= 0) ? "+" : "-"
      end
    else
      json.taxes charge_code.charge_code_generates.tax(current_hotel) do |charge_code_generate|
        json.charge_code_id charge_code_generate.generate_charge_code_id.to_s
        json.is_inclusive charge_code_generate.is_inclusive
        json.calculation_rules charge_code_generate.tax_calculation_rule_charge_codes.map {|x| x.id}
      end
    end
    
  end

end

json.total_count @addons.total_count unless @no_pagination
