class OwsReservationApi
  def self.get_booking(hotel_id, confirm_no)
    hotel = Hotel.find(hotel_id)
    use_kiosk_entity = hotel.settings.use_kiosk_entity_id_for_fetch_booking
    reservation_service = OwsReservationService.new(hotel_id, use_kiosk_entity)

    message = OwsMessage.new
    message.append_confirmation_number(confirm_no)
    message.append_hotel_reference(hotel_id)
    message.append_use_vault(hotel_id)

    reservation_service.fetch_booking message, '//FetchBookingResponse', lambda { |operation_response|
      OwsCommonApi.parse_booking_response(hotel_id, confirm_no, operation_response)
    }
  end

  # call to checkin the reservation
  def self.check_in(hotel_id, reservation, no_post, card_info)
    hotel = Hotel.find(hotel_id)
    use_snt_entity = hotel.settings.use_snt_entity_id_for_checkin_checkout ? false : true
    reservation_service = OwsResvAdvancedService.new(hotel_id, use_snt_entity)

    message = OwsMessage.new
    message.append_reservation_request(hotel_id, reservation.external_id)
    message.append_credit_card_info(reservation.hotel, card_info) if card_info
    message.append_kiosk_info(false)
    message.append_no_post(no_post) if no_post

    reservation_service.check_in message, '//CheckInResponse', lambda { |operation_response|
      OwsCommonApi.parse_checkin_response(hotel_id, operation_response.xpath('CheckInComplete'))
    }
  end

  # Assigns the room number for a reservation
  def self.assign_room(hotel_id, external_id, room_no)
    reservation_service = OwsReservationService.new(hotel_id)

    message = OwsMessage.new
    message.append_hotel_reference(hotel_id)
    message.append_resv_name_id(external_id)
    message.append_room_no_requested(room_no)

    reservation_service.assign_room message, '//AssignRoomResponse', lambda { |operation_response|
      { room_assigned: operation_response.xpath('RoomNoAssigned').text }
    }
  end

  # Releases the room number for a reservation
  def self.release_room(hotel_id, external_id)
    reservation_service = OwsReservationService.new(hotel_id)

    message = OwsMessage.new
    message.append_hotel_reference(hotel_id)
    message.append_resv_name_id(external_id)

    reservation_service.release_room message, '//ReleaseRoomResponse'
  end

  # Method to add or update wake up calls
  def self.add_wakeup_calls(wakeup_calls_data, action)
    guest_service = OwsGuestServices.new(wakeup_calls_data[:hotel_id])

    message = OwsMessage.new
    message.append_hotel_reference(wakeup_calls_data[:hotel_id])
    message.append_resv_name_id_internal(wakeup_calls_data[:external_id])
    message.append_room_no_tag(wakeup_calls_data[:room_no])

    if action != 'FETCH'
      message.append_wake_up_call_details(wakeup_calls_data)
    end

    message.append_action_type(action)

    # call method wake up call to external pms
    guest_service.wake_up_call message, '//WakeUpCallResponse' , lambda { |operation_response|
      OwsCommonApi.parse_checkin_response(wakeup_calls_data[:hotel_id], operation_response.xpath('Result'))
    }
  end

  # call to check-out the reservation
  def self.check_out(hotel_id, reservation)
    hotel = Hotel.find(hotel_id)
    use_snt_entity = hotel.settings.use_snt_entity_id_for_checkin_checkout ? false : true
    reservation_service = OwsResvAdvancedService.new(hotel_id, use_snt_entity)

    message = OwsMessage.new
    message.append_reservation_request(hotel_id, reservation.external_id)
    message.append_email_folio

    reservation_service.check_out message, '//CheckOutResponse', lambda { |operation_response|
      OwsCommonApi.parse_check_out_response(hotel_id, operation_response.xpath('CheckOutComplete'))
    }
  end

  # Calls OWS modify_booking for changed reservation information
  def self.modify_booking(hotel_id, confirm_no, changed_attributes, remote_checkout, use_kiosk)
    reservation_service = OwsReservationService.new(hotel_id, use_kiosk)

    message = OwsMessage.new
    message.append_changed_booking_attributes(hotel_id, confirm_no, changed_attributes, remote_checkout)

    reservation_service.modify_booking message, '//ModifyBookingResponse', lambda { |operation_response|
      OwsCommonApi.parse_booking_response(hotel_id, confirm_no, operation_response)
    }
  end

  # Calls OWS update payment method to change payment method on reservation information
  def self.update_payment_method(hotel_id, external_id, card_info)
    reservation_service = OwsResvAdvancedService.new(hotel_id)

    message = OwsMessage.new
    message.append_update_payment_attributes(hotel_id, external_id, card_info)

    reservation_service.update_method_of_payment message, '//UpdateMethodOfPaymentResponse'
  end

  # Calls OWS guest requests to comments on reservation
  def self.guest_comment_requests(hotel_id, confirm_no, action_type, comments)
    reservation_service = OwsReservationService.new(hotel_id)

    message = OwsMessage.new
    message.append_comment_attributes(hotel_id, confirm_no, action_type, comments)

    reservation_service.guest_requests message, '//GuestRequestsResponse', lambda { |operation_response|
      OwsCommonApi.parse_comments_response(hotel_id, operation_response.xpath('GuestRequests'))
    }
  end

  def self.queue_reservation(hotel_id, external_id, queue_status)
    reservation_advanced_service = OwsResvAdvancedService.new(hotel_id)
    message = OwsMessage.new
    message.append_reservation_request(hotel_id, external_id)
    action_type = queue_status == "true" ? 'ADD' : 'DELETE'
    message.append_action_type(action_type)

    reservation_advanced_service.queue_reservation message, '//QueueReservationResponse', lambda { |operation_response|
      operation_response.xpath('QueueMessage').text
    }
  end

  # Calls OWS guest requests to set alerts on reservation
  def self.guest_alert_requests(hotel_id, confirm_no, action_type, alert_area, alert_code, alert_desc)
    reservation_service = OwsReservationService.new(hotel_id)

    message = OwsMessage.new
    message.append_alert_attributes(hotel_id, confirm_no, action_type, alert_area, alert_code, alert_desc)

    reservation_service.guest_requests message, '//GuestRequestsResponse'
  end

  def self.send_smartband_key_data(hotel_id, key_2_track, reservation_external_id)
    reservation_service = OwsResvAdvancedService.new(hotel_id)

    message = OwsMessage.new
    message.append_hotel_reference(hotel_id)
    message.append_reservation_id(reservation_external_id)
    message.append_smartband_key_data(key_2_track)
    reservation_service.set_key_data message, '//SetKeyDataResponse'
  end
end
