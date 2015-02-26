json.front_office_statuses @front_office_statuses do |front_office_status|
  json.id 			front_office_status.id
  json.value 		front_office_status.value
  json.description 	front_office_status.description
end