json.results @work_types do |work_type|
  json.id work_type.id
  json.name work_type.name
  json.is_active work_type.is_active
  json.is_system work_type.is_system
end

json.total_count @work_types.total_count