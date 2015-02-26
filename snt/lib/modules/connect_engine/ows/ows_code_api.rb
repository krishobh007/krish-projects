class OwsCodeApi
  def self.get_transaction_codes(hotel_id)
    information_service = OwsInformationService.new(hotel_id)
    hotel = Hotel.find(hotel_id)

    message = OwsMessage.new
    message.append_lov_query(hotel_id, 'TRXCODES')

    information_service.lov message, '//LovResponse', lambda { |operation_response|
      operation_response.xpath('//LovValue').map do |value|
        {
          charge_code: value.text,
          description: value.xpath('@description').text
        }
      end
    }
  end

  def self.get_rate_codes(hotel_id)
    information_service = OwsInformationService.new(hotel_id)

    message = OwsMessage.new
    message.append_lov_query(hotel_id, 'RATECODES')

    information_service.lov message, '//LovResponse', lambda { |operation_response|
      operation_response.xpath('//LovValue').map do |value|
        {
          code: value.text,
          description: value.xpath('@description').text
        }
      end
    }
  end

  def self.get_addons(hotel_id)
    information_service = OwsInformationService.new(hotel_id)

    message = OwsMessage.new
    message.append_resort_reference(hotel_id)
    
    information_service.package_items message, '//PackageItemsResponse', lambda { |operation_response|
      operation_response.xpath('//Package').map do |package_tag|
        {
          package_code: package_tag.xpath('@packageCode').text,
          short_description: package_tag.xpath('ShortDescription/Text/TextElement').text,
          description: package_tag.xpath('Description/Text/TextElement').text,
          is_included_in_rate: package_tag.xpath('@includedInRate').text == "true",
          begin_date: package_tag.xpath('StartDate').text,
          end_date: package_tag.xpath('EndDate').text
        }
      end
    }
  end

end
