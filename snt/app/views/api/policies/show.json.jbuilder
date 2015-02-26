json.call(@policy, :id, :name, :description, :amount, :amount_type, :post_type_id, :apply_to_all_bookings, :advance_days, :policy_type_id, :allow_deposit_edit)
json.advance_time current_hotel.utc_to_hotel_time(@policy.advance_time).andand.strftime('%I:%M %p')
json.charge_code_id @policy.charge_code.present? ? @policy.charge_code.id.to_s : ""
