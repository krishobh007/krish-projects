json.results @restriction_types do |restriction_type|
  json.call(restriction_type, :id, :value, :description, :editable)
  json.activated restriction_type.activated?(current_hotel)
end

json.total_count @restriction_types.total_count
