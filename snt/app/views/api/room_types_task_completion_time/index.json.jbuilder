json.results @room_types.each do |room_type|
  task = room_type.tasks.first
  room_type_completion_time = task.room_type_tasks.
                              where(room_type_id: room_type.id).first.andand.
                              completion_time if task.present?
  completion_time = task.present? ? (room_type_completion_time.present? ? room_type_completion_time : task.andand.completion_time) : nil
  completion_time_in_min = completion_time.andand.strftime("%H").to_i * 60 + completion_time.andand.strftime("%M").to_i
  json.room_type_id room_type.id.to_s
  json.housekeeping_task_completion_time completion_time_in_min
end