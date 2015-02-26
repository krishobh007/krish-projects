class HotelMailer < ActionMailer::Base
  default content_type: 'text/html'

  # Send the email sent check in confirmation
  def send_staff_checkin_confirmation(hotel, email, reservations)
    @hotel = hotel
    @email = email
    @guests = guests_response(reservations)
    @total_guests_count = @guests.count
    @time = hotel.settings.checkin_alert_time.andand.in_time_zone(hotel.tz_info).andand.strftime('%I:%M %p').to_s
    @type = I18n.t('mailer.staff_email_sent_confirmation.check_in')

    mail(from: hotel.hotel_from_address, to: email, subject: I18n.t('mailer.subject.staff_checkin_confirmation')) do |format|
      format.html { render 'staff_email_sent_confirmation' }
    end
  end

  # Send the email sent check out confirmation
  def send_staff_checkout_confirmation(hotel, email, reservations, alert_time)
    @hotel = hotel
    @email = email
    @guests = guests_response(reservations)
    @total_guests_count = @guests.count
    @time = alert_time.andand.in_time_zone(hotel.tz_info).andand.strftime('%I:%M %p').to_s
    @type = I18n.t('mailer.staff_email_sent_confirmation.check_out')

    mail(from: hotel.hotel_from_address, to: email, subject: I18n.t('mailer.subject.staff_checkout_confirmation')) do |format|
      format.html { render 'staff_email_sent_confirmation' }
    end
  end

  #--- SEND STAFF ALERTES ON QUEUE ROOMS ---#
  def send_staff_alerts_on_queue_reservation(hotel,reservation)
    @hotel = hotel
    emails = hotel.staff_alert_emails.queue_reservation_alerts.pluck(:email)
    primary_guest = reservation.primary_guest
    @guest_name = primary_guest.andand.full_name
    @room_no = reservation.current_room_number
    @confirm_no = reservation.confirm_no
    
    mail(from: hotel.hotel_from_address, to: emails, subject: I18n.t('mailer.subject.staff_queue_reservation',confirm_no: reservation.confirm_no.to_s)) do |format|
      format.html { render 'staff_alert_on_queue_reservation' }
    end
  end

  def send_reservations_export(hotel, file)
    @hotel = hotel
    subject = I18n.t('mailer.subject.reservations_export', hotel_name: hotel.name, date: Date.today)
    attachments['reservations.csv'] = File.read(file)
    to_address = hotel.settings.reservations_export_email_address
    mail(from: 'admin@stayntouch.com', to: hotel.settings.reservations_export_email_address, subject: subject) if to_address
  end

  private

  # Create the response for the guests
  def guests_response(reservations)
    reservations.map do |reservation|
      guest = reservation.primary_guest

      {
        guest_name: guest.full_name,
        room_no: reservation.current_daily_instance.room.andand.room_no,
        payment_type: reservation.primary_payment_method.andand.payment_type.andand.description,
        email: guest.email
      }
    end
  end
end
