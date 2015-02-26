json.data @reservations do |reservation|
	json.id reservation.id
	json.checkin_date reservation.arrival_date.andand.strftime('%b %d').upcase
	json.guest_name abbreviated_name(reservation.first_name.to_s, reservation.last_name.to_s)
	json.first_name reservation.first_name.to_s
	json.last_name reservation.last_name.to_s
	json.room_type reservation.room_type.to_s
	json.total_nights reservation.total_nights
	json.room_no reservation.room_no.to_s
	json.number_of_adults reservation.adults.to_s
	json.number_of_children reservation.children.to_s
	json.accompanying_guests_count reservation.accompanying_guests.count
	json.is_allow_checkout_from_kiosk reservation.is_allow_checkout_from_kiosk
	json.is_before_standard_checkin_time current_hotel.checkin_time.present? ? 
	                                      Time.now.utc < ActiveSupport::TimeZone[current_hotel.tz_info].parse(
	                                      current_hotel.checkin_time.strftime("%H:%M")).utc : false
	json.has_ready_room reservation.current_daily_instance.room.present? && 
							reservation.current_daily_instance.room.andand.is_ready?
	json.is_rate_suppressed reservation.rate_suppressed.nil? ? false : !reservation.rate_suppressed.zero?
	json.is_rooms_available_in_pms !reservation.current_daily_instance.room_type.room_nos_excluding_due_in.empty?
	json.is_prepaid_reservation reservation.deposit_paid > 0
	json.is_early_checkin_purchased reservation.is_early_checkin_bundled
 end