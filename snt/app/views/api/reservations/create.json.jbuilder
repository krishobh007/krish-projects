allow_deposit_edit = true
json.reservations @reservations_list.each do |reservation|
  json.id reservation.id
  json.room_id reservation.daily_instances.first.room_id
  json.confirm_no reservation.confirm_no
  json.is_routing_available reservation.charge_routings.any?
  json.status ViewMappings::StayCardMapping.map_view_status(reservation, reservation.hotel.active_business_date)
  json.deposit_amount ('%.2f' % reservation.deposit_amount).to_s 
  json.fees_details reservation.bill_payment_method(1).andand.fees_information(reservation.hotel) || {}
  allow_deposit_edit = allow_deposit_edit &&  reservation.current_daily_instance.rate.andand.deposit_policy.andand.allow_deposit_edit
  allow_deposit_edit = true if allow_deposit_edit.nil?
end
json.allow_deposit_edit @allow_deposit_edit 