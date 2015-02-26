class ConnectEngineApi
  # When a new instance of a child class is created, the appropriate API will be looked up using the pms type for the hotel.
  # This API will be used by the instance of the child class.
  def initialize(hotel_id, connection_params = nil)
    @hotel_id = hotel_id
    @connect_api_class = find_pms_for_hotel(@hotel_id)
  end

  private

  # Get the PMS Connector Class for the hotel
  def find_pms_for_hotel(hotel_id)
    pms_type = find_pms_type_for_hotel(hotel_id)
    find_pms_connector_class_for_type(pms_type)
  end

  # Find the PMS Type for the hotel
  def find_pms_type_for_hotel(hotel_id)
    pms_type = Hotel.find(hotel_id).pms_type

    fail "PMS Type not configured for hotel_id: #{hotel_id}" unless pms_type

    pms_type.value
  end

  # Derive the PMS Connector Class using the PMS Type
  def find_pms_connector_class_for_type(pms_type)
    pms_connector_class = Object.const_get(pms_type.to_s.capitalize + self.class.to_s)

    unless pms_connector_class
      fail "PMS Connector Class not configured for type: #{pms_type}"
    end

    pms_connector_class
  end
end
