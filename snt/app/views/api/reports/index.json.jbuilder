json.results @reports do |report|
  json.call(report, :id, :title, :sub_title, :description)

  json.filters report.filters do |filter|
    json.call(filter, :value, :description)
  end

  json.sort_fields report.sortable_fields do |sort_field|
    json.call(sort_field, :value, :description)
  end
end

json.total_count @reports.total_count
