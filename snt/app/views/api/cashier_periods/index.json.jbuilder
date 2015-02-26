if !@cashiers.empty?
  json.cashiers @cashiers do |cashier|
    json.id cashier.id
    json.name cashier.full_name
  end
end
json.status @cashier_period_status
json.current_user_id current_user.id
if !@history.empty?
  json.history @history do |cashier_period|
    json.partial! 'cashier_period_details', cashier_period: cashier_period
  end
end