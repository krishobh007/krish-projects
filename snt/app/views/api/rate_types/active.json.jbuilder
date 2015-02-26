json.array! @rate_types do |rate_type|
  json.call(rate_type, :id, :name)
end
