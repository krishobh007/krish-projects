module SixPayment
  module Web2Pay
    module Authorization
      
      class Client
        
        WSDL_URL = "https://web2payuat.3cint.com/mxg/service/_2011_02_v5_1_0/Authorise.asmx?WSDL"
        
        def initialize(hotel)
          @client = Savon.client(wsdl: WSDL_URL, convert_request_keys_to: :none)
          @hotel = hotel
        end
        
        def operations
          @client.operations
        end
        
        def get_status_by_tx_id(tx_id)
          raise Web2PayClientError, 'Six payment configuration is not present' if @hotel.settings.six_merchant_id.nil? &&  @hotel.settings.six_validation_code.nil?
          
          begin
            response = @client.call(:get_status_by_tx_id, message: { 
              :eMerchantID    => @hotel.settings.six_merchant_id,
              :ValidationCode => @hotel.settings.six_validation_code,
              :TxID           => tx_id,
              :OptionFlags    => "G"
            })
            Response::GetStatusByTxId.new(response.body)
          rescue Savon::SOAPFault => ex
            logger.error "#{ex.message} - #27. Web2Pay::Authorization::Client"
          end
        end
      end
    end
  end
end