class OwsReservationService < OwsService
  SERVICE_NAME = 'Reservation.asmx'
  WSDL_URL = 'http://webservices.micros.com/ows/5.1/Reservation.wsdl'

  # Remote soap operation names
  soap_operation :fetch_booking
  soap_operation :assign_room
  soap_operation :release_room
  soap_operation :modify_booking
  soap_operation :guest_requests

  # Instantiate the SOAP client for the hotel and WSDL name
  def initialize(hotel_id, use_kiosk = false)
    super(hotel_id, SERVICE_NAME, WSDL_URL, use_kiosk: use_kiosk)
  end
end
