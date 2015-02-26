json.results do
  json.id @billing_group.id
  json.name @billing_group.name
  json.selected_charge_codes @billing_group.charge_codes do |charge_code|
    json.array! charge_code.id
  end
end