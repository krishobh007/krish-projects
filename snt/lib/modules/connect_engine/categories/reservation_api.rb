# Used to process reservations in a remote API
class ReservationApi < ConnectEngineApi
  # Get the booking information for the hotel
  def get_booking(confirm_no)
    @connect_api_class.get_booking(@hotel_id, confirm_no)
  end

  # Check in the reservation for the hotel
  def check_in(reservation, no_post, card_info)
    @connect_api_class.check_in(@hotel_id, reservation, no_post, card_info)
  end

  # Assign room number for a reservation
  def assign_room(external_id, room_no)
    @connect_api_class.assign_room(@hotel_id, external_id, room_no)
  end

  # Send wake up calls for the reservation and room for the hotel
  def add_wakeup_calls(wakeup_calls_data, action)
    @connect_api_class.add_wakeup_calls(wakeup_calls_data, action)
  end

  # Check-out the reservation for the hotel
  def check_out(reservation)
    @connect_api_class.check_out(@hotel_id, reservation)
  end

  # Assign room number for a reservation
  def release_room(external_id)
    @connect_api_class.release_room(@hotel_id, external_id)
  end

  # Update the booking information
  def modify_booking(confirm_no, changed_attributes, remote_checkout = false, use_kiosk = false)
    @connect_api_class.modify_booking(@hotel_id, confirm_no, changed_attributes, remote_checkout, use_kiosk)
  end

  # Update the booking information
  def update_payment_method(external_id, card_info)
    @connect_api_class.update_payment_method(@hotel_id, external_id, card_info)
  end

  # Update the booking information
  def guest_comment_requests(confirm_no, action_type, comments)
    @connect_api_class.guest_comment_requests(@hotel_id, confirm_no, action_type, comments)
  end

  # Queue - Deque a specific reservation.(status will be true/false)
  def queue_reservation(external_id, status)
    @connect_api_class.queue_reservation(@hotel_id, external_id, status)
  end

  # Send alerts
  def guest_alert_requests(confirm_no, action_type, alert_area, alert_code, alert_desc)
    @connect_api_class.guest_alert_requests(@hotel_id, confirm_no, action_type, alert_area, alert_code, alert_desc)
  end

  #Send smartband to external PMS
  def send_smartband_key_data(key_2_track, reservation_external_id)
    @connect_api_class.send_smartband_key_data(@hotel_id, key_2_track, reservation_external_id)
  end
end
