class OwsAvailabilityApi
  # Fetch the guest information from OWS
  def self.availability(hotel_id, begin_date, end_date, room_type, rate_code, promotion_code)
    availability_service = OwsAvailabilityService.new(hotel_id, false)
    message = OwsMessage.new

    # hotel_id = "1", begin_Date = "2013-12-13", end_date = "2013-12-13", room_type = "STTD", rate_code = "UPS"
    message.append_availability_attributes(hotel_id, begin_date, end_date, room_type, rate_code, promotion_code)

    # Calling the availability API in SOAP
    availability_service.availability message, '//AvailabilityResponse'
  end
end
