json.transactions transactions  do |transaction|
  json.id transaction.id
  reservation = transaction.bill.reservation
  json.room reservation.current_daily_instance.room.andand.room_no
  json.name reservation.primary_guest.andand.full_name
  json.reservation_number reservation.confirm_no
  if transaction.is_eod_transaction == true && transaction.transaction_type != 'DELETED'
    type = 'EOD'
  else
    type = transaction.transaction_type
  end
  json.type type

  details = transaction.comments
  actions = Action.where('actionable_type = "FinancialTransaction" AND actionable_id = ?', transaction.id)
  detail = []
  actions.each do |action|
    action_details = action.details
    action_details.each do |action_detail|
      if action.action_type === :EDIT_TRANSACTION || action.action_type === :SPLIT_TRANSACTION
        detail << '%.2f' % action_detail.old_value + " edited to " + action_detail.new_value if !action.details.empty?
      end
    end
  end
  details = details.to_s + detail.join(", ")
  
  
  json.date transaction.date
  json.time transaction.time.andand.in_time_zone(current_hotel.tz_info).andand.strftime("%I:%M %P")
   
  json.debit (tran_type == 'revenue') ? transaction.amount : ''
  json.credit (tran_type == 'payment') ? transaction.amount : ''
  if transaction.is_eod_transaction == true
    department_id = nil
    employee_id = nil
    employee_name = 'End of Day'
  else
    department_id = transaction.updater.andand.department_id
    employee_id = transaction.updater_id
    employee_name = transaction.user.andand.full_name  
  end
  json.department_id department_id
  json.employee_id employee_id
  json.employee_name employee_name
  details = (details.to_s + "<br />" + transaction.reference_number) if transaction.reference_number
  details = (details.to_s + "<br />- " + employee_name) if employee_name
  
  details = (details.to_s + "<br />- " + transaction.reference_text) unless transaction.reference_text.nil?
  
  json.details details.html_safe
end