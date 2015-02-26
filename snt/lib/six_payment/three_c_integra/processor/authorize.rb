module SixPayment
  module ThreeCIntegra
    module Processor
      class Authorize
        
        def initialize(hotel, credit_card)
          @credit_card = credit_card
          @hotel = hotel
        end
        
        def process(attributes)
          amount = attributes[:amount]
          type = attributes[:type]
          currency_code = attributes[:currency_code]
          @workstation = Workstation.where(:hotel_id => @hotel.id).first
          
          if type == 'pre_auth'
            @credit_card_transaction = CreditCardTransaction.create(
              :hotel => @hotel,
              :amount => amount,
              :credit_card_transaction_type => Ref::CreditCardTransactionType[:AUTHORIZATION],
              :status => false,
              :payment_method => @credit_card,
              :sequence_number => 0
            )
            pre_auth(amount, currency_code)
          elsif type == 'pre_auth_terminal'
            @credit_card_transaction = CreditCardTransaction.create(
              :hotel => @hotel,
              :amount => amount,
              :credit_card_transaction_type => Ref::CreditCardTransactionType[:AUTHORIZATION],
              :status => false,
              :sequence_number => 0
            )
            pre_auth_terminal(amount, currency_code)
          elsif type == 'topup'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where(:credit_card_transaction_type_id => Ref::CreditCardTransactionType[:AUTHORIZATION].id).last
            topup(amount, currency_code)
          elsif type == "pre_auth_reversal"
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where(:credit_card_transaction_type_id => Ref::CreditCardTransactionType[:AUTHORIZATION].id).last
            
            pre_auth_reversal             
          elsif type == 'topup_reversal'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where(:credit_card_transaction_type_id => Ref::CreditCardTransactionType[:TOPUP].id).last
            
            topup_reversal
          end
        end
        
        private
        
        def pre_auth(amount, currency_code)
          request_obj = SixPayment::ThreeCIntegra::Request::EftAuthorizationEmv.new(
            :sequence_number => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num => @credit_card_transaction.id,
            :requester_location_id => @hotel.settings.six_server_location_id,
            :amount => amount,
            :token  => @credit_card.mli_token,
            :currency => currency_code,
            :eft_authorization_type => 'Preauth',
            :card_input_method => 'M'
          )
          out_put_response = call_end_point(request_obj)
          
          if out_put_response.is_a?(SixPayment::ThreeCIntegra::Response::Error)
            # Error occurs
          else out_put_response.is_a?(SixPayment::ThreeCIntegra::Response::EftAuthorizationEmv)
            update_transaction(out_put_response)
          end
          
          @credit_card_transaction
        end
        
        def pre_auth_terminal(amount, currency_code)
          raise SixPayment::ThreeCIntegra::ThreeCIntegraInvalidParameters, "Atleast one workstation should be configured." if @workstation.nil?
          
          request_obj = SixPayment::ThreeCIntegra::Request::EftAuthorizationEmv.new(
            :sequence_number => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num => @credit_card_transaction.id,
            :requester_location_id => @hotel.settings.six_server_location_id,
            :amount => amount,
            :currency => currency_code,
            :eft_authorization_type => 'Preauth-Terminal',
            :emv_scenario_id          => 'DT',
            :emv_terminal_id          => @workstation.station_identifier,
            :card_input_method => 'S'
          )
#           
          out_put_response = call_end_point(request_obj)
          if out_put_response.result == 'A'
            # Success 
          else
            reason_to_fail = SixPayment::ThreeCIntegra::BankInterfaceReturnValues::CODE_VALUES[out_put_response.result_reason]
            reason_to_fail ||= out_put_response.message
            
            raise SixPayment::ThreeCIntegra::ThreeCIntegraSettlementError, 
                  "#{I18n.t 'payment_failed_message'} #{reason_to_fail}"
          end
          out_put_response
        end
        
        def topup(amount, currency_code)
          request_obj = SixPayment::ThreeCIntegra::Request::EftAuthorizationEmv.new(
            :sequence_number => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num => @credit_card_transaction.id,
            :requester_location_id => @hotel.settings.six_server_location_id,
            :amount => amount,
            :eft_authorization_type => 'TopUp',
            :currency => currency_code,
            :token  => @credit_card.mli_token
          )
          out_put_response = call_end_point(request_obj)
          
          if out_put_response.result == 'A'
            update_transaction(out_put_response)
          end
          
          @credit_card_transaction
        end
        
        def pre_auth_reversal
          request_obj = SixPayment::ThreeCIntegra::Request::EftAuthorizationEmv.new(
            :sequence_number => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num => @credit_card_transaction.id,
            :requester_location_id => @hotel.settings.six_server_location_id,
            :amount => @credit_card_transaction.amount,
            :eft_authorization_type => 'PreAuth-Reversal',
            :bank_auth_code         => @credit_card_transaction.authorization_code,
            :token  => @credit_card.mli_token
          )
          out_put_response = call_end_point(request_obj)
          
          if out_put_response.result == 'A'
            update_transaction(out_put_response)
          end
          
          @credit_card_transaction
        end
        
        def topup_reversal
          request_obj = SixPayment::ThreeCIntegra::Request::EftAuthorizationEmv.new(
            :sequence_number => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num => @credit_card_transaction.id,
            :requester_location_id => @hotel.settings.six_server_location_id,
            :amount => @credit_card_transaction.amount,
            :eft_authorization_type => 'TopUp-Reversal',
            :bank_auth_code         => @credit_card_transaction.authorization_code,
            :token  => @credit_card.mli_token
          )
          out_put_response = call_end_point(request_obj)
          
          if out_put_response.result == 'A'
            update_transaction(out_put_response)
          end
          
          @credit_card_transaction
        end
        
        def update_transaction(out_put_response)
          @credit_card_transaction.authorization_code       = out_put_response.bank_auth_code
          @credit_card_transaction.currency_code            =  Ref::CurrencyCode[out_put_response.currency_used]
          @credit_card_transaction.req_reference_no         = out_put_response.requester_trans_ref_num
          @credit_card_transaction.sequence_number          = out_put_response.sequence_number
          @credit_card_transaction.emv_terminal_id          = out_put_response.emv_terminal_id
          @credit_card_transaction.is_emv_authorized        = out_put_response.emv_authorized == 'Y' ? true : false
          @credit_card_transaction.is_emv_pin_verified      = out_put_response.emv_pin_verified == 'Y' ? true : false
          @credit_card_transaction.external_message         = out_put_response.message
          @credit_card_transaction.external_failure_reason  = out_put_response.result_reason
          @credit_card_transaction.sequence_number          = out_put_response.sequence_number
          @credit_card_transaction.external_print_data      = out_put_response.print_data2
          
          if out_put_response.eft_authorization_type == 'TopUp'
            @credit_card_transaction.credit_card_transaction_type = Ref::CreditCardTransactionType[:TOPUP]
          elsif out_put_response.eft_authorization_type == 'TopUp-Reversal' or out_put_response.eft_authorization_type == 'PreAuth-Reversal'
            @credit_card_transaction.credit_card_transaction_type = Ref::CreditCardTransactionType[:REVERSAL]
          end
          @credit_card_transaction.save
        end
        
        def call_end_point(request_body)
          SixPayment::ThreeCIntegra::Connector::Synchronous::Message.new(request_body.to_xml, @hotel).response
        end
        
      end
    end
  end
end