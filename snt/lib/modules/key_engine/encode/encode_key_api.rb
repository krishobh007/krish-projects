class EncodeKeyApi
  # Fetch the guest information from OWS
  def self.create_key(hotel_id, reservation, reservation_key, email, host_with_port, called_from_rover, options = {})
    data = {}
    key_system = Hotel.find(hotel_id).key_system

    @connect_tablet_api_class = find_key_system_connector_class(key_system)
    key_system_response = @connect_tablet_api_class.request_key(reservation, reservation_key.room_number, reservation_key.number_of_keys, options)
    if key_system_response[:status]

      data = {
        action: 'tablet',
        key_info: key_system_response[:data],
        card_type: key_system.key_card_type.description,
        aid: key_system.aid,
        keyb: key_system.keyb
      }
      { status: true, data: data, errors: [] }
    else
      { status: false, data: [], errors: key_system_response[:errors] }
    end
  end

  private

  def self.find_key_system_connector_class(key_system)
    if key_system.value == "SAFLOK_MSR"
      key_connector_class = Object.const_get(key_system.to_s.downcase.camelize + 'KeyApi')
    else
      key_connector_class = Object.const_get(key_system.to_s.downcase.capitalize + 'KeyApi')
    end
    unless key_connector_class
      fail "KEY Connector Class not configured for type: #{key_system}"
    end

    key_connector_class
  end
end
