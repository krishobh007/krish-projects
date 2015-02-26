json.results @search_array do |result|
    json.id  result[:id]
    json.name result[:name]
    json.type result[:type]
end
