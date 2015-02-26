json.data do 
	json.id @reservation.id
	json.checkin_date @reservation.arrival_date.andand.strftime('%b %d').upcase
	json.room_no @reservation.current_daily_instance.andand.room.andand.room_no
	json.first_name @reservation.primary_guest.first_name.to_s.capitalize
	json.email_address @reservation.primary_guest.email
	json.guest_name abbreviated_name(@reservation.primary_guest.first_name.to_s, @reservation.primary_guest.last_name.to_s)
	json.last_name @reservation.primary_guest.last_name.to_s.capitalize
	json.accompanying_guests_count @reservation.accompanying_guests.count
	json.has_ready_room  @reservation.current_daily_instance.room.present? && 
							@reservation.current_daily_instance.room.andand.is_ready?
	json.is_rate_suppressed  @reservation.is_rate_suppressed
	json.is_rooms_available_in_pms !@reservation.current_daily_instance.room_type.room_nos_excluding_due_in.empty?
	json.room_type @reservation.current_daily_instance.room_type.andand.room_type_name.to_s
	json.total_nights (@reservation.departure_date - @reservation.arrival_date).to_i
	json.is_allow_checkout_from_kiosk @reservation.is_allow_checkout_from_kiosk
	json.number_of_adults @reservation.current_daily_instance.adults.to_s
	json.number_of_children @reservation.current_daily_instance.children.to_s
	json.is_prepaid_reservation @deposit_attributes_hash[:deposit_paid].to_f > 0
	json.is_before_standard_checkin_time @reservation.arrival_time.present? ? Time.now.utc < @reservation.arrival_time.utc : false
	json.is_early_checkin_purchased @reservation.is_early_checkin_bundled
    json.primary_guest_id @reservation.primary_guest.present? ? @reservation.primary_guest.id.to_s : ''
    json.is_email_present @reservation.has_valid_email_address
end