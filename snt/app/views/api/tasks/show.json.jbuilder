json.call(@task, :id, :name, :work_type_id, :front_office_status_ids, :room_type_ids, :is_occupied, :is_vacant, :completion_time)
json.reservation_statuses_ids @task.ref_reservation_hk_status_ids
json.task_completion_hk_status_id @task.ref_housekeeping_status_id
json.room_types_completion_time @room_types_completion_time