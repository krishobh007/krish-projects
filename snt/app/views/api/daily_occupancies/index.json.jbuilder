json.results @dates do |date|
  json.date date.strftime('%Y-%m-%d')

  json.actual @occupancies.select { |occupancy| occupancy[:date] == date }.first.andand[:occupancy]
  json.target @targets.select { |target| target[:date] == date }.first.andand[:target]
end

json.total_count @dates.total_count
