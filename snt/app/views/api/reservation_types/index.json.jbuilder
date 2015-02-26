if @hotel.is_third_party_pms_configured?
  json.reservation_types @reservation_types do |reservation_type|
    json.name reservation_type
    json.is_active true
  end
else
 json.reservation_types @reservation_types do |reservation_type|
    json.value reservation_type.andand.id
    json.name reservation_type.description
    json.is_active true # @hotel.reservation_types.include?(reservation_type)
  end
end

