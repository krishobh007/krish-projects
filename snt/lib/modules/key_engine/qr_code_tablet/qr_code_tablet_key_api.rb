class QrCodeTabletKeyApi
  # Return qr code for display on tablet
  # Create key and email
  def self.create_key(hotel_id, reservation, reservation_key, email, host_with_port, called_from_rover, options = {})
    errors = []
    data = {}
    if reservation_key
      data = {
        action: 'qr_code_tablet',
        key_info: ActiveSupport::Base64.encode64(reservation_key.qr_data)
      }
      { status: true, data: data, errors: errors }
    else
      errors = 'Key data for resrevation not found'
      { status: false, data: [], errors: errors }
    end
  end
end
