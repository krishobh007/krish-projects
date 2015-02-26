json.array! @billing_groups do |billing_group|
  json.id billing_group.id
  json.name billing_group.name
  json.is_already_used is_already_used_in_reservation(billing_group)
end