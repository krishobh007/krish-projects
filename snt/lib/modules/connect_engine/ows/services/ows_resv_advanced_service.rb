class OwsResvAdvancedService < OwsService
  SERVICE_NAME = 'ResvAdvanced.asmx'
  WSDL_URL = 'http://webservices.micros.com/ows/5.1/ResvAdvanced.wsdl'
  REQUEST_NAMESPACE = 'http://webservices.micros.com/og/4.3/ResvAdvanced/'

  # Remote soap operation names
  soap_operation :fetch_room_status
  soap_operation :fetch_room_setup
  soap_operation :check_in
  soap_operation :invoice
  soap_operation :check_out
  soap_operation :make_payment
  soap_operation :update_method_of_payment
  soap_operation :post_charge
  soap_operation :folio_transaction_transfer
  soap_operation :queue_reservation
  soap_operation :set_key_data

  # Instantiate the SOAP client for the hotel and WSDL name
  def initialize(hotel_id, use_kiosk = false)
    super(hotel_id, SERVICE_NAME, WSDL_URL, request_namespace: REQUEST_NAMESPACE, override_client_namespace: true, use_kiosk: use_kiosk)
  end
end
