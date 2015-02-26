class OwsAvailabilityService < OwsService
  SERVICE_NAME = 'Availability.asmx'
  WSDL_URL = 'http://webservices.micros.com/ows/5.1/Availability.wsdl'
  REQUEST_NAMESPACE = 'http://webservices.micros.com/og/4.3/Availability/'

  # Remote soap operation names
  soap_operation :availability
  soap_operation :fetch_calendar

  # Instantiate the SOAP client for the hotel and WSDL name
  def initialize(hotel_id, use_kiosk = false)
    super(hotel_id, SERVICE_NAME, WSDL_URL, request_namespace: REQUEST_NAMESPACE, use_kiosk: use_kiosk)
  end
end
