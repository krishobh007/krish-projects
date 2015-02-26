module SixPayment
  module Web2Pay
    module Pay
      
      class Client
        
        WSDL_URL = "https://web2payuat.3cint.com/mxg/service/_2011_02_v5_1_0/Pay.asmx?WSDL"
        
        def initialize(reservation)
          @client = Savon.client(wsdl: WSDL_URL, convert_request_keys_to: :none)
          @hotel = reservation.hotel
          @reservation = reservation
        end
        
        def operations
          @client.operations
        end
        
        def get_status_by_tx_id(token)
          raise Web2PayClientError, 'Six payment configuration is not present' if @hotel.settings.six_merchant_id.nil? &&  @hotel.settings.six_validation_code.nil?
          
          begin
            response = @client.call(:get_status_by_tx_id, message: { 
              :eMerchantID    => @hotel.settings.six_merchant_id,
              :ValidationCode => @hotel.settings.six_validation_code,
              :CardNumber     => token,
              :MerchantRef    => @reservation.id,
              :OptionFlags    => "P"
            })
            Response::RequestNoCardRead.new(response.body)
          rescue Savon::SOAPFault => ex
            logger.error "#{ex.message} - #27. Web2Pay::Authorization::Client"
          end
        end
      end
    end
  end
end