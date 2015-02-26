json.array! @reference_values do |reference_value|
  json.call(reference_value, :id, :value, :description)
end
