json.reservation_statuses @reservation_hk_statuses do |reservation_status|
  json.id 			reservation_status.id
  json.value 		reservation_status.value
  json.description 	reservation_status.description
end