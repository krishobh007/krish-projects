module SixPayment
  module ThreeCIntegra
    module Processor
      class Settlement
        
        def initialize(hotel, credit_card)
          
          # raise ThreeCIntegraInvalidParameters, "Missing Credit Card Data" if credit_card.nil?
          
          @credit_card = credit_card
          @hotel = hotel
          
          raise ThreeCIntegraInvalidParameters, "Missing 3CIntegra Location Settings" if @hotel.settings.six_server_location_id.nil?
        end
        
        def process(attributes)
          amount = attributes[:amount]
          type = attributes[:type]
          currency_code = attributes[:currency_code]
          @workstation = Workstation.where(:hotel_id => @hotel.id).first
          
          if type == 'completion'
            @type = 'Completion'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where("credit_card_transaction_type_id = ? OR credit_card_transaction_type_id = ?", Ref::CreditCardTransactionType[:AUTHORIZATION].id, Ref::CreditCardTransactionType[:TOPUP].id)
                            .last
            completion(amount, currency_code)
          elsif type == 'sale'
            @type = 'Sale'
            @credit_card_transaction = CreditCardTransaction.create(
              :hotel => @hotel,
              :amount => amount,
              :credit_card_transaction_type => Ref::CreditCardTransactionType[:PAYMENT],
              :status => false,
              :payment_method => @credit_card
            )
            sale(amount, currency_code)
          elsif type == 'sale_terminal'
            
            @type = 'Sale'
            @credit_card_transaction = CreditCardTransaction.create(
              :hotel => @hotel,
              :amount => amount,
              :credit_card_transaction_type => Ref::CreditCardTransactionType[:PAYMENT],
              :status => false
              # :payment_method => @credit_card
            )
            sale_terminal(amount, currency_code)
          elsif type == 'refund'
            @type = 'Refund'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where("credit_card_transaction_type_id = ? OR credit_card_transaction_type_id = ?", Ref::CreditCardTransactionType[:PAYMENT].id, Ref::CreditCardTransactionType[:SETTLEMENT].id)
                            .last
                            
            refund(amount, currency_code)
          elsif type == 'refund_terminal'
            @type = 'Refund'
            raise SixPayment::ThreeCIntegra::ThreeCIntegraInvalidParameters, "No prior transaction is found to make refund for credit card" if @credit_card.nil?
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where("credit_card_transaction_type_id = ? OR credit_card_transaction_type_id = ?", Ref::CreditCardTransactionType[:PAYMENT].id, Ref::CreditCardTransactionType[:SETTLEMENT].id)
                            .last
                            
            refund_terminal(amount, currency_code)
          elsif type == 'auth_settle_reversal'
            @type = 'Sale-Reversal'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where(:credit_card_transaction_type_id => Ref::CreditCardTransactionType[:PAYMENT].id).last
            sale_reversal
          elsif type == 'settle_reversal'
            @type = 'Completion-Reversal'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where(:credit_card_transaction_type_id => Ref::CreditCardTransactionType[:AUTHORIZATION].id).last
            completion_reversal(amount, currency_code)
          elsif type == 'refund_reversal'
            @type = 'Refund-Reversal'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where(:credit_card_transaction_type_id => Ref::CreditCardTransactionType[:REFUND].id).last
            refund_reversal
          end
        end
        
        private
        
        def completion(amount, currency_code)
          request_obj = SixPayment::ThreeCIntegra::Request::EftSettlementEmv.new(
            :sequence_number          => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num  => @credit_card_transaction.id,
            :requester_location_id    => @hotel.settings.six_server_location_id,
            :amount                   => amount,
            :eft_settlement_type      => 'Completion',
            :token                    => @credit_card.mli_token,
            :bank_auth_code           => @credit_card_transaction.authorization_code,
            :currency                 => currency_code,
            :request_type             => 'EftSettlement'
          )
          out_put_response = call_end_point(request_obj)
          
          if out_put_response.result == 'A'
            update_transaction(out_put_response)
          end
          
          @credit_card_transaction
        end
        
        
        def sale(amount, currency_code)
          request_obj = SixPayment::ThreeCIntegra::Request::EftSettlementEmv.new(
            :sequence_number          => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num  => @credit_card_transaction.id,
            :requester_location_id    => @hotel.settings.six_server_location_id,
            :amount                   => amount,
            :eft_settlement_type      => 'Sale',
            :token                    => @credit_card.mli_token,
            :card_input_method        => 'M',
            :currency                 => currency_code
          )
          
          out_put_response = call_end_point(request_obj)
          update_transaction(out_put_response)
          
          if out_put_response.result == 'A'
            # update_sale_transaction(out_put_response)
          else
            reason_to_fail = SixPayment::ThreeCIntegra::BankInterfaceReturnValues::CODE_VALUES[out_put_response.result_reason]
            reason_to_fail ||= out_put_response.message
            
            raise SixPayment::ThreeCIntegra::ThreeCIntegraSettlementError, 
                  "#{I18n.t 'payment_failed_message'} #{reason_to_fail}"
          end
          @credit_card_transaction
        end
        
        def sale_terminal(amount, currency_code)
          raise SixPayment::ThreeCIntegra::ThreeCIntegraInvalidParameters, "Atleast one workstation should be configured." if @workstation.nil?
          
          request_obj = SixPayment::ThreeCIntegra::Request::EftSettlementEmv.new(
            :sequence_number          => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num  => @credit_card_transaction.id,
            :requester_location_id    => @hotel.settings.six_server_location_id,
            :amount                   => amount,
            :eft_settlement_type      => 'Sale-Terminal',
            :currency                 => currency_code,
            :emv_scenario_id          => 'DT',
            :emv_terminal_id          => @workstation.station_identifier,
            :card_input_method        => 'S'
          )
          
          out_put_response = call_end_point(request_obj)
          update_transaction(out_put_response)
          
          if out_put_response.result == 'A'
            credit_card_last4 = out_put_response.token.split(//).last(4).to_s if out_put_response.token.present?
            card_type = Ref::CreditCardType[Setting.six_payment_card_types[out_put_response.card_scheme_id.to_sym]] if out_put_response.card_scheme_id.present?
            card_expiry = Date.strptime(out_put_response.card_expiry_date,"%m%y").to_s if out_put_response.card_expiry_date.present?
            payment_method = PaymentMethod.create(
              :card_expiry => card_expiry,
              :mli_token => out_put_response.token,
              :credit_card_type => card_type,
              :payment_type => PaymentType.credit_card,
              :skip_credit_card_info_validation => true
            )
            @credit_card_transaction.payment_method = payment_method
            @credit_card_transaction.save
            
          else
            reason_to_fail = SixPayment::ThreeCIntegra::BankInterfaceReturnValues::CODE_VALUES[out_put_response.result_reason]
            reason_to_fail ||= out_put_response.message
            
            raise SixPayment::ThreeCIntegra::ThreeCIntegraSettlementError, 
                  "#{I18n.t 'payment_failed_message'} #{reason_to_fail}"
          end
          @credit_card_transaction
        end
        
        
        def refund(amount, currency_code)
          raise SixPayment::ThreeCIntegra::ThreeCIntegraInvalidParameters, "No prior transaction is found to make refund for credit card ending with #{@credit_card.mli_token_display}" if @credit_card_transaction.nil?
          
          request_obj = SixPayment::ThreeCIntegra::Request::EftSettlementEmv.new(
            :sequence_number          => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num  => @credit_card_transaction.id,
            :requester_location_id    => @hotel.settings.six_server_location_id,
            :amount                   => amount,
            :eft_settlement_type      => 'Refund',
            :token                    => @credit_card.mli_token,
            :currency                 => currency_code
          )
          
          out_put_response = call_end_point(request_obj)
          if out_put_response.result == 'A'
            update_transaction(out_put_response)
          else
            reason_to_fail = SixPayment::ThreeCIntegra::BankInterfaceReturnValues::CODE_VALUES[out_put_response.result_reason]
            reason_to_fail ||= out_put_response.message
            
            raise SixPayment::ThreeCIntegra::ThreeCIntegraSettlementError, 
                  "#{I18n.t 'payment_failed_message'} #{reason_to_fail}"
          end
          
          @credit_card_transaction
        end
        
        def refund_terminal(amount, currency_code)
          raise SixPayment::ThreeCIntegra::ThreeCIntegraInvalidParameters, "No prior transaction is found to make refund for credit card ending with #{@credit_card.mli_token_display}" if @credit_card_transaction.nil?
          
          request_obj = SixPayment::ThreeCIntegra::Request::EftSettlementEmv.new(
            :sequence_number          => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num  => @credit_card_transaction.id,
            :requester_location_id    => @hotel.settings.six_server_location_id,
            :amount                   => amount,
            :eft_settlement_type      => 'Refund-Terminal',
            :currency                 => currency_code,
            :card_input_method        => 'S',
            :emv_scenario_id          => 'DT',
            :emv_terminal_id          => @workstation.station_identifier
          )
          
          out_put_response = call_end_point(request_obj)
          if out_put_response.result == 'A'
            update_transaction(out_put_response)
          else
            reason_to_fail = SixPayment::ThreeCIntegra::BankInterfaceReturnValues::CODE_VALUES[out_put_response.result_reason]
            reason_to_fail ||= out_put_response.message
            
            raise SixPayment::ThreeCIntegra::ThreeCIntegraSettlementError, 
                  "#{I18n.t 'payment_failed_message'} #{reason_to_fail}"
          end
          
          @credit_card_transaction
        end
        
        def sale_reversal
          request_obj = SixPayment::ThreeCIntegra::Request::EftSettlementEmv.new(
            :sequence_number          => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num  => @credit_card_transaction.id,
            :requester_location_id    => @hotel.settings.six_server_location_id,
            :amount                   => @credit_card_transaction.amount,
            :eft_settlement_type      => 'Sale-Reversal',
            :token                    => @credit_card.mli_token,
            :bank_auth_code           => @credit_card_transaction.autherization_code,
            :currency                 => @credit_card_transaction.currency_code.value
          )
          out_put_response = call_end_point(request_obj)
          
          if out_put_response.result == 'A'
            update_transaction(out_put_response)
          end
          
          @credit_card_transaction
        end
        
        def completion_reversal(amount, currency_code)
          request_obj = SixPayment::ThreeCIntegra::Request::EftSettlementEmv.new(
            :sequence_number          => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num  => @credit_card_transaction.id,
            :requester_location_id    => @hotel.settings.six_server_location_id,
            :amount                   => @credit_card_transaction.amount,
            :eft_settlement_type      => 'Completion-Reversal',
            :token                    => @credit_card.mli_token,
            :bank_auth_code           => @credit_card_transaction.autherization_code,
            :currency                 => currency_code
          )
          out_put_response = call_end_point(request_obj)
          
          if out_put_response.result == 'A'
            update_transaction(out_put_response)
          end
          
          @credit_card_transaction
        end
        
        def refund_reversal
          request_obj = SixPayment::ThreeCIntegra::Request::EftSettlementEmv.new(
            :sequence_number          => @credit_card_transaction.class.get_sequence_number,
            :requester_trans_ref_num  => @credit_card_transaction.id,
            :requester_location_id    => @hotel.settings.six_server_location_id,
            :amount                   => @credit_card_transaction.amount,
            :eft_settlement_type      => 'Refund-Reversal',
            :token                    => @credit_card_transaction.token,
            :bank_auth_code           => @credit_card_transaction.autherization_code,
            :currency                 => currency_code
          )
          out_put_response = call_end_point(request_obj)
          
          # if out_put_response.result == 'A'
            update_transaction(out_put_response)
          # end
          
          @credit_card_transaction
        end
            
        def update_transaction(out_put_response)
          @credit_card_transaction.authorization_code       = out_put_response.bank_auth_code
          @credit_card_transaction.currency_code            = Ref::CurrencyCode[out_put_response.currency_used]
          @credit_card_transaction.req_reference_no         = out_put_response.requester_trans_ref_num
          @credit_card_transaction.sequence_number          = out_put_response.sequence_number
          @credit_card_transaction.emv_terminal_id          = out_put_response.emv_terminal_id
          @credit_card_transaction.is_emv_authorized        = out_put_response.emv_authorized == 'Y' ? true : false
          @credit_card_transaction.is_emv_pin_verified      = out_put_response.emv_pin_verified == 'Y' ? true : false
          @credit_card_transaction.external_message         = out_put_response.message
          @credit_card_transaction.external_failure_reason  = out_put_response.result_reason
          @credit_card_transaction.sequence_number          = out_put_response.sequence_number
          @credit_card_transaction.external_print_data      = out_put_response.print_data2
          @credit_card_transaction.status                   = true
          
          if @type == 'Completion'
            @credit_card_transaction.credit_card_transaction_type = Ref::CreditCardTransactionType[:SETTLEMENT]
          elsif @type == 'Sale'
            @credit_card_transaction.credit_card_transaction_type = Ref::CreditCardTransactionType[:PAYMENT]
          elsif @type == 'Refund-Reversal' or @type == 'Completion-Reversal' or @type == 'Sale-Reversal'
            @credit_card_transaction.credit_card_transaction_type = Ref::CreditCardTransactionType[:REVERSAL]
          end
          @credit_card_transaction.save
        end
        
        def update_sale_transaction(out_put_response)
          @credit_card_transaction.sequence_number = out_put_response.sequence_number
          @credit_card_transaction.authorization_code = out_put_response.bank_auth_code
          @credit_card_transaction.currency_code =  Ref::CurrencyCode[out_put_response.currency_used]
          @credit_card_transaction.req_reference_no = out_put_response.requester_trans_ref_num
          @credit_card_transaction.external_transaction_id = out_put_response.bank_auth_code
          @credit_card_transaction.emv_terminal_id = out_put_response.emv_terminal_id
          @credit_card_transaction.is_emv_authorized = out_put_response.emv_authorized == 'Y' ? true : false
          @credit_card_transaction.is_emv_pin_verified = out_put_response.emv_pin_verified == 'Y' ? true : false
          @credit_card_transaction.external_message = out_put_response.message
          @credit_card_transaction.status = true
          @credit_card_transaction.save
        end
        
        def call_authorize_end_point(request_body, is_settle=true)
          if is_settle
            dummy_output = File.open("#{Rails.root}/tmp/test_files/EftSettle.xml")
          else
            dummy_output = File.open("#{Rails.root}/tmp/test_files/EftSale.xml")
          end
          SixPayment::ThreeCIntegra::Response::EftSettlementEmv.new(dummy_output)
        end
        
        def call_end_point(request_body)
          SixPayment::ThreeCIntegra::Connector::Synchronous::Message.new(request_body.to_xml, @hotel).response
        end
        
      end
    end
  end
end