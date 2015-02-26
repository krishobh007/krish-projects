class EmailKeyApi
  # Create key and email
  def self.create_key(hotel_id, reservation, reservation_key, email, host_with_port, called_from_rover, options = {})
    result = {}
    data = {}
    # call the key system based on the system hotel is using
    if called_from_rover
      # call staff send reservation systems
      begin
        ReservationMailer.staff_send_reservation_key(reservation_key.id, host_with_port, reservation, email).deliver!
        data = {
          action: 'email',
          key_info: 'Reservation Key has been emailed'
        }
        result = { status: true, data: data, errors: [] }

     rescue Net::SMTPAuthenticationError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
       result = { status: false, data: [], errors: ['Unable to email the reservation key'] }

      end
      result
    else
      # call guest send reservation systems
      begin

        ReservationMailer.guest_send_reservation_key(reservation_key.id, host_with_port, reservation).deliver!
        data = {
          action: 'email',
          key_info: 'Reservation Key has been emailed'
        }

        result = { status: true, data: data, errors: [] }

     rescue ArgumentError, Net::SMTPAuthenticationError, Net::SMTPError, Net::SMTPServerBusy, Net::SMTPSyntaxError, Net::SMTPFatalError, Net::SMTPUnknownError => e
       result = { status: false, data: [], errors: ['Unable to email the reservation key'] }

      end
      result
    end
  end
end
