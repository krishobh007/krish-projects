amount_owing = 0
json.open_guest_bills @open_ar_transactions.count
json.currency_code current_hotel.default_currency.andand.symbol
@available_credits = @account.available_credits(current_hotel)
json.available_credit @available_credits

json.ar_transactions @ar_transactions do |transaction|
  json.transaction_id transaction.id
  json.guest_first_name transaction.first_name
  json.guest_last_name transaction.last_name
  json.guest_is_vip transaction.is_vip
  json.reservation_arrival_date transaction.arrival_date
  json.reservation_dep_date transaction.dep_date
  json.reservation_arrival_time transaction.arrival_time.andand.in_time_zone(@hotel.tz_info).andand.strftime("%H:%M")
  json.reservation_dep_time transaction.departure_time.andand.in_time_zone(@hotel.tz_info).andand.strftime("%H:%M")
  json.is_hourly transaction.reservation.is_hourly
  json.reservation_confirm_no transaction.confirm_no

  if transaction.paid_on.present?
    paid = true
  else
    paid = false
    amount_owing += transaction.debit
  end
  json.paid paid 
  json.amount transaction.debit
  json.bill_id transaction.bill_id
  guest_detail = GuestDetail.find(transaction.guest_id)
  json.guest_image guest_detail.avatar.andand.url(:thumb).to_s
  json.reservation_id transaction.reservation_id
end

json.amount_owing amount_owing - @available_credits
json.total_count @total_count
