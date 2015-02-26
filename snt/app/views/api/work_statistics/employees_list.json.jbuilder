json.results @maids.each do |maid|
  json.id maid.id
  json.maid_name maid.andand.detail.andand.full_name
end

json.total_count @maids.total_count