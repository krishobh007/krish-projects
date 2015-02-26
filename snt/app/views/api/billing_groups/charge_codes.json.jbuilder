  json.available_charge_codes current_hotel.charge_codes.order('charge_code').charge do |charge_code|
    json.id charge_code.id
    json.charge_code charge_code.charge_code
    json.description charge_code.description
  end