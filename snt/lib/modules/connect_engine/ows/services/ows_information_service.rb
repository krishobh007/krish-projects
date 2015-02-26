class OwsInformationService < OwsService
  SERVICE_NAME = 'Information.asmx'
  WSDL_URL = 'http://webservices.micros.com/ows/5.1/Information.wsdl'

  # Remote soap operation names
  soap_operation :lov, soap_action: :query_lov
  soap_operation :package_items, soap_action: :query_package_items

  # Instantiate the SOAP client for the hotel and WSDL name
  def initialize(hotel_id, connection_params = nil)
    super(hotel_id, SERVICE_NAME, WSDL_URL, use_kiosk: true, connection_params: connection_params)
  end
end
