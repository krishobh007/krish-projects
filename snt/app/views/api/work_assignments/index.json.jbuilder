json.unassigned @unassigned_rooms.each do |room|
  room_data = get_reservation(room, @date, @is_business_date)
  json.call(room_data, :id, :room_no, :current_status, :checkin_time, :checkout_time,
            :room_type, :is_vip, :floor_number, :is_queued, :reservation_status, :fo_status)
  json.time_allocated get_time_allocated(@date, room, @work_type)
end

json.work_sheets @employees.each do |employee|
  json.employee_id employee.id
  json.employee_name employee.andand.staff_detail.andand.full_name

  # Get the work sheet of the user in the requested date
  work_sheet = employee.work_sheets.where(date: @date, work_type_id: @work_type.id).first

  json.work_sheet_id work_sheet.andand.id
  json.shift work_sheet.andand.shift.andand.time.andand.strftime("%I:%M")

  work_assignments = work_sheet.andand.work_assignments || []

  json.work_assignments work_assignments.each do |work_assignment|
    json.work_assignment_id work_assignment.id
    json.task_id work_assignment.task_id

    room = work_assignment.room

    json.room do
      room_data = get_reservation(room, @date, @is_business_date)
      json.call(room_data, :id, :room_no, :current_status, :checkin_time, :checkout_time,
                :room_type, :is_vip, :floor_number, :is_queued, :reservation_status, :fo_status)
      json.time_allocated get_time_allocated(@date, room, @work_type)
      json.hk_complete assignment_completed?(work_assignment)
    end
  end
end
