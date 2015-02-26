json.results @tasks do |task|
  room_types_completion_time = {}
  task.room_type_ids.each do |room_type_id|
    room_type_task =  RoomTypeTask.find_by_room_type_id_and_task_id(room_type_id, task.id)
    room_types_completion_time[room_type_id] = room_type_task.andand.completion_time.andand.strftime("%H:%M")
    json.room_type_id task.room_type_id
    json.task_completion_hk_status_id task.ref_housekeeping_status_id
    json.room_types_completion_time room_types_completion_time
  end
 
  json.id task.id
  json.name task.name
  json.work_type_id task.work_type_id
  json.work_type_name task.work_type.andand.name
  json.room_type_ids task.room_type_ids
  json.front_office_status_ids task.front_office_status_ids
  json.reservation_statuses_ids task.ref_reservation_hk_status_ids
  json.is_occupied task.is_occupied
  json.is_vacant task.is_vacant
  json.completion_time task.completion_time.andand.strftime("%H:%M")
  json.task_completion_hk_status_id task.ref_housekeeping_status_id
  json.is_system task.is_system
end

json.total_count @tasks.total_count