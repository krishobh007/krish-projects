json.results @smartbands do |smartband|
  json.call(smartband, :id, :first_name, :last_name, :is_fixed, :amount, :account_number)
end

json.total_count @smartbands.total_count
