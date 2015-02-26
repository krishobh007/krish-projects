json.total_cash_received cashier_period.total_cash_received(current_hotel)
json.total_check_received cashier_period.total_checks_received(current_hotel)
json.opening_balance_cash cashier_period.opening_balance_cash
json.opening_balance_check cashier_period.opening_balance_check
json.cash_submitted cashier_period.cash_submitted
json.check_submitted cashier_period.checks_submitted
json.status cashier_period.status
user_name = cashier_period.updater_id ? cashier_period.updater.full_name : "EOD"
json.user user_name
json.id cashier_period.id
time = [cashier_period.ends_at, cashier_period.starts_at].compact.max
time = time.andand.in_time_zone(current_hotel.tz_info) if time
json.time time.andand.strftime('%I:%M %P') if time
json.date time.andand.strftime('%Y-%m-%d') if time


