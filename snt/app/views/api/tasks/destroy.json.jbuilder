json.id @task.id
json.name @task.name
json.work_type_id @task.work_type_id
json.room_type_ids @task.room_types.pluck(:id)
json.is_occupied @task.is_occupied
json.is_vacant @task.is_vacant
json.completion_time @task.completion_time
json.ref_housekeeping_status_id @task.ref_housekeeping_status_id

