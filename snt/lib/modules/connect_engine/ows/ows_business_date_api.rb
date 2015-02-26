class OwsBusinessDateApi
  def self.get_business_date(hotel_id, connection_params = nil)
    information_service = OwsInformationService.new(hotel_id, connection_params)
    hotel = Hotel.find(hotel_id)

    message = OwsMessage.new
    message.append_lov_query(hotel_id, 'BUSINESSDATE')

    information_service.lov message, '//LovResponse', lambda { |operation_response|
      business_date_response = operation_response.xpath('//LovQueryResult')
      business_date_response.xpath('@tertiaryQualifierValue').text + '-' + business_date_response.xpath('@secondaryQualifierValue').text + '-' + business_date_response.xpath('@qualifierValue').text
    }
  end
end
