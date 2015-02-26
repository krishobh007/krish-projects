json.results @ranges do |range|
  json.call(range, :id, :value)
end

json.total_count @ranges.total_count