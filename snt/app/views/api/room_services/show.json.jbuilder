json.call(@inactive_room, :room_id, :ref_service_status_id, :maintenance_reason_id, :comments)
json.from_date @from_date
json.to_date @to_date