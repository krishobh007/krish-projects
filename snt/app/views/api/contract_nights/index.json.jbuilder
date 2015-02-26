json.results @contract_nights do |contract_night|
  json.month contract_night.month_year.strftime('%b')
  json.year contract_night.month_year.strftime('%Y')
  json.no_of_nights contract_night.no_of_nights
end

json.total_nights @contract_nights.sum(:no_of_nights)
