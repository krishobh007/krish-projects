json.results @charge_groups do |charge_group|
  json.id charge_group.id
  json.name charge_group.charge_group
  json.description charge_group.description
end

json.total_count @charge_groups.total_count
