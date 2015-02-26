json.is_routing_available @reservation.charge_routings.any?
json.deposit_amount ('%.2f' % @reservation.balance_deposit_amount).to_s
json.fees_details @reservation.bill_payment_method(1).andand.fees_information(current_hotel) || {}
json.allow_deposit_edit @reservation.current_daily_instance.andand.rate.andand.deposit_policy.andand.allow_deposit_edit
json.reservation_status @reservation.andand.status.andand.to_s
