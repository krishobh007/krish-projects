json.array! @date_ranges do |date_range|
  json.id date_range.id
  json.begin_date date_range.begin_date
  json.end_date date_range.end_date
end
