json.results @types do |type|
  json.call(type, :id, :value)
end

json.total_count @types.total_count