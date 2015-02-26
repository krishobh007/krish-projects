json.results @charge_codes do |charge_code|
  json.id charge_code.id
  json.name charge_code.charge_code
  json.description charge_code.description
  json.associcated_charge_groups charge_code.charge_groups do |charge_group|
    json.id charge_group.id
  end
end

json.total_count @charge_codes.total_count
