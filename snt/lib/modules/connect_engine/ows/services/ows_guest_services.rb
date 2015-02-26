class OwsGuestServices < OwsService
  SERVICE_NAME = 'GuestServices.asmx'
  WSDL_URL = 'http://webservices.micros.com/ows/5.1/GuestServices.wsdl'
  REQUEST_NAMESPACE = 'http://webservices.micros.com/og/4.3/GuestServices/'

  # Remote soap operation names
  soap_operation :wake_up_call

  # OWS call for changing room status in
  soap_operation :update_room_status

  # Instantiate the SOAP client for the hotel and WSDL name
  def initialize(hotel_id)
    super(hotel_id, SERVICE_NAME, WSDL_URL, request_namespace: REQUEST_NAMESPACE, override_client_namespace: true)
  end
end
