json.charge_groups @charge_groups do |charge_group|
  json.id charge_group.id
  json.name charge_group.description
  json.code charge_group.charge_group
  json.charge_codes charge_group.charge_codes do |charge_code|
    json.id charge_code.id
    json.name charge_code.description
    json.code charge_code.charge_code
    json.total charge_code.financial_transactions.sum(:amount).round(2)
    json.transactions charge_code.financial_transactions do |transaction|
      reservation = transaction.bill.reservation
      credit_amount = transaction.charge_code.charge_code_type_id == Ref::ChargeCodeType[:PAYMENT].id ? transaction.amount : ''
      debit_amount = transaction.charge_code.charge_code_type_id != Ref::ChargeCodeType[:PAYMENT].id ? transaction.amount : ''
      json.room reservation.current_daily_instance.room.andand.room_no
      json.name reservation.primary_guest.andand.full_name
      json.reservation_number reservation.confirm_no
      json.type ''
      json.details ''
      json.time transaction.updated_at
      json.debit debit_amount
      json.credit credit_amount
      json.department_id transaction.updater.department_id
      json.employee_id transaction.updater_id
    end
  end
end
