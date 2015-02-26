class MailPreview < MailView
  # Preview staff check in confirmation
  def send_staff_checkin_confirmation
    hotel = Hotel.first
    reservations = hotel.reservations.order('id desc').limit(5)
    email = hotel.web_checkin_staff_alert_emails.first.andand.email

    HotelMailer.send_staff_checkin_confirmation(hotel, email, reservations)
  end

  # Preview staff check out confirmation
  def send_staff_checkout_confirmation
    hotel = Hotel.first
    reservations = hotel.reservations.order('id desc').limit(5)
    email = hotel.web_checkout_staff_alert_emails.checkout_alerts.first.andand.email

    HotelMailer.send_staff_checkout_confirmation(hotel, email, reservations)
  end

  # Preview staff pre_checkin confirmation
  def alert_staff_on_pre_checkin_success
    hotel = Hotel.first
    reservation = hotel.reservations.first
    recipient = hotel.web_checkin_staff_alert_emails.first.andand.email
    ReservationMailer.alert_staff_on_pre_checkin_success(reservation,recipient)
  end

  # Preview confirmation email sending
  def send_confirmation_number_mail
    hotel = Hotel.first
    reservation = hotel.reservations.first
    email = hotel.web_checkout_staff_alert_emails.first.andand.email

    ReservationMailer.send_confirmation_number_mail(reservation, email)
  end

  #---   PREVIEW STAFF QUEUE RESERVATION EMAIL   ---#
  def send_staff_alerts_on_queue_reservation
    hotel = Hotel.first
    reservation = hotel.reservations.last

    HotelMailer.send_staff_alerts_on_queue_reservation(hotel, reservation)
  end

 # Preview confirmation email sending
  def send_guest_bill
    reservation = Reservation.find(37137)
    hotel = reservation.hotel
    ReservationMailer.send_guest_bill(reservation, reservation.bills.first)
  end

  def send_guest_password_reset_email
    user = User.find(5)
    UserNotifier.send_guest_password_reset_email(user)
  end
end

