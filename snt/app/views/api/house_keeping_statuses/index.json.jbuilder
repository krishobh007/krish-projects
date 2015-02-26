json.house_keeping_statuses @house_keeping_statuses do |house_keeping_status|
	json.id house_keeping_status.id
	json.value house_keeping_status.value
	json.description house_keeping_status.description
end