json.last_cashier_period_id @last_cashier_period_id
json.history @history do |cashier_period|
  json.partial! 'cashier_period_details', cashier_period: cashier_period
end