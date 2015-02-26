class SmartphoneKeyApi
  # Return qr code for display on smartphone
  # Create key
  def self.create_key(hotel_id, reservation, reservation_key, email, host_with_port, called_from_rover, options = {})
    errors = []
    data = {}
    if reservation_key
      data = {
        action: 'smartphone',
        key_info: ActiveSupport::Base64.encode64(reservation_key.qr_data)
      }

      { status: true, data: data, errors: errors }
    else
      errors = 'Key data for reservation not found'
      { status: false, data: [], errors: errors }
    end
  end
end
