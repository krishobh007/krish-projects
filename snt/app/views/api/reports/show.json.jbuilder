json.title @report.title
json.sub_title @report.sub_title
json.description @report.description

json.filters @report.filters do |filter|
  json.call(filter, :value, :description)
end

json.sort_fields @report.sortable_fields do |sort_field|
  json.call(sort_field, :value, :description)
end
