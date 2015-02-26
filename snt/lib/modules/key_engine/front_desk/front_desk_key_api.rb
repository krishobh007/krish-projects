class FrontDeskKeyApi
  # Return qr code for display on tablet
  # Create key and email
  def self.create_key(hotel_id, reservation, reservation_key, email, host_with_port, called_from_rover, options = {})
    errors = []
    data = {}
    if reservation_key
      data = {
        action: 'front_desk',
        key_info: 'Please pick up key from front desk'
      }

      { status: true, data: data, errors: errors }

    else
      errors = 'Key data for reservation not found'
      { status: false, data: [], errors: errors }
    end
  end
end
