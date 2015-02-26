json.results @service_status do |service_status|
  json.call(service_status, :id, :value, :description)
end

json.total_count @service_status.total_count