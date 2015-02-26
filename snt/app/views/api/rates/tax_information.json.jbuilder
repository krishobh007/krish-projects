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
json.tax_information @tax_information