class ConnectKeyApi
  # When a new instance of a child class is created, the appropriate API will be looked up using the key system for the hotel.
  # This API will be used by the instance of the child class.
  def initialize(hotel_id, called_from_rover = false, connection_params = nil)
    @hotel_id = hotel_id
    @called_from_rover = called_from_rover
    if @called_from_rover
      @connect_api_class_rover = find_key_setup_rover_for_hotel(@hotel_id)
    else
      @connect_api_class_zest = find_key_setup_zest_for_hotel(@hotel_id)
    end
  end

  private

  # Get the Key System Connector Class for the hotel (zest)
  def find_key_setup_zest_for_hotel(hotel_id)
    key_type = find_key_system_zest_for_hotel(hotel_id)
    find_key_connector_class_for_type(key_type)
  end

  # Get the Key System Connector Class for the hotel (rover)
  def find_key_setup_rover_for_hotel(hotel_id)
    key_type = find_key_system_rover_for_hotel(hotel_id)
    find_key_connector_class_for_type(key_type)
  end

  # Find the Key System for the hotel(zest)
  def find_key_system_zest_for_hotel(hotel_id)
    key_type = Hotel.find(hotel_id).settings.room_key_delivery_for_guestzest_check_in || Setting.defaults[:room_key_delivery_for_guestzest_check_in]
    fail "KEY Type not configured for hotel_id: #{hotel_id}" unless key_type
    if key_type == Setting.zest_key_delivery_options[:front_desk]
      key_type = Setting.zest_key_delivery_options[:email]
    end
    key_type
  end

  # Find the Key System for the hotel(rover)
  def find_key_system_rover_for_hotel(hotel_id)
    key_type = Hotel.find(hotel_id).settings.room_key_delivery_for_rover_check_in || Setting.defaults[:room_key_delivery_for_rover_check_in]
    fail "KEY Type not configured for hotel_id: #{hotel_id}" unless key_type

    key_type
  end

  # Derive the KEY Connector Class using the Key Type
  def find_key_connector_class_for_type(key_type)
    key_connector_class = Object.const_get(key_type.to_s.camelize + self.class.to_s)

    unless key_connector_class
      fail "KEY Connector Class not configured for type: #{key_type}"
    end

    key_connector_class
  end
end
