class OwsNameService < OwsService
  SERVICE_NAME = 'Name.asmx'
  WSDL_URL = 'http://webservices.micros.com/ows/5.1/Name.wsdl'

  # Remote soap operation names
  soap_operation :fetch_profile
  soap_operation :insert_address
  soap_operation :insert_credit_card
  soap_operation :insert_email
  soap_operation :insert_guest_card
  soap_operation :insert_phone
  soap_operation :insert_preference
  soap_operation :update_address
  soap_operation :update_credit_card
  soap_operation :update_email
  soap_operation :update_guest_card
  soap_operation :update_name
  soap_operation :update_passport
  soap_operation :update_phone
  soap_operation :delete_address
  soap_operation :delete_credit_card
  soap_operation :delete_email
  soap_operation :delete_guest_card
  soap_operation :delete_passport
  soap_operation :delete_phone
  soap_operation :delete_preference
  soap_operation :insert_update_privacy_option, soap_action: :insert_update_privacy

  # Instantiate the SOAP client for the hotel and WSDL name
  def initialize(hotel_id)
    super(hotel_id, SERVICE_NAME, WSDL_URL)
  end
end
