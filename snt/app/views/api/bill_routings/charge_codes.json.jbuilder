json.array! @charge_codes do |charge_code|
  json.id charge_code.id
  json.code charge_code.charge_code
  json.description charge_code.description
  json.is_already_used is_already_used_in_reservation(charge_code)
end