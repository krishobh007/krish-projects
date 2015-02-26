json.maintenance_reasons @maintenance_reasons do |reason|
  json.value reason.id
  json.name reason.maintenance_reason
end


