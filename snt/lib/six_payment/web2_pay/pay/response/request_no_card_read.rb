module SixPayment
  module Web2Pay
    module Pay
      module Response
        
        class RequestNoCardRead < BaseResponse
          attr_accessor :tx_id, :authorisation_code, :authorise_amount, :capture_amount, 
                        :currency, :merchant_ref, :return_text, :tx_state, :tx_state_text, :cvv2_result_code,
                        :card_number_last4, :card_type, :card_expiry_yymm, :token_no, :token_expiry_yymm
        end
        
      end
    end
  end
end