json.charge_codes @charge_codes.each do |charge_code|
  json.id charge_code.id
  json.charge_code charge_code.charge_code
end