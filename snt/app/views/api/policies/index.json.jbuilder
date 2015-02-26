json.results @policies do |policy|
  json.call(policy, :id, :name, :description, :amount, :amount_type, :post_type_id, :policy_type_id)
end

json.total_count @policies.total_count
