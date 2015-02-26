module SixPayment
  module Web2Pay
    module Token
      
      class Client
        
        WSDL_URL = Setting.six_token_service_wsdl
        
        def initialize(hotel)
          @client = Savon.client(wsdl: WSDL_URL, convert_request_keys_to: :none)
          @hotel = hotel
        end
        
        def operations
          @client.operations
        end
        
        def check_token(token)
          raise Web2PayClientError, 'Six payment configuration is not present' if @hotel.settings.six_merchant_id.nil? &&  @hotel.settings.six_validation_code.nil?
          
          begin
            response = @client.call(:check_token, message: { 
              :eMerchantID    => @hotel.settings.six_merchant_id,
              :ValidationCode => @hotel.settings.six_validation_code,
              :TokenNo        => token,
              :OptionFlags    => ""
            })
            Response::CheckToken.new(response.body)
          rescue Savon::SOAPFault => ex
            logger.error "#{ex.message} - #27. Web2Pay::Authorization::Client"
          end
        end
      end
    end
  end
end