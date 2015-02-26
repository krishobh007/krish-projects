module MerchantLink
  module Lodging
    module Processor
      class Authorize < Mli
        include Connector
        
        def process(attributes = {})
          @credit_card  = attributes[:payment_method]
          type          = attributes[:type]
          amount        = attributes[:amount]
          checkin_date  = attributes[:checkin_date]
          checkout_date = attributes[:checkout_date] 
               
          raise InvalidParameterError, "The authorize amount should be greater or equal to $1" unless (amount.present? && (amount && amount.to_i >= 1))
          
          @credit_card_transaction = nil
          
          if type == 'pre_auth'
            @credit_card_transaction = CreditCardTransaction.create(
              :hotel => @hotel,
              :amount => amount,
              :credit_card_transaction_type => Ref::CreditCardTransactionType[:AUTHORIZATION],
              :status => false,
              :payment_method => @credit_card,
              :sequence_number => 0
            )
            pre_authorize(amount, checkin_date, checkout_date)
          elsif type == 'topup'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where("credit_card_transaction_type_id = ? OR credit_card_transaction_type_id = ?", Ref::CreditCardTransactionType[:AUTHORIZATION].id, Ref::CreditCardTransactionType[:TOPUP].id)
                            .last
            topup(amount)
          elsif type == 'auth_reverse'
            @credit_card_transaction = @credit_card.credit_card_transactions
                            .where("credit_card_transaction_type_id = ? OR credit_card_transaction_type_id = ?", Ref::CreditCardTransactionType[:AUTHORIZATION].id, Ref::CreditCardTransactionType[:TOPUP].id)
                            .last
            
            reverse_auth(amount)
          end
        end
        
        private
        
        def pre_authorize(amount, checkin_date, checkout_date)
          message = Lodging::Message::pre_auth_message({
            :company_code => @company_code,
            :site_code    => @site_code,
            :expiry_date  => @credit_card.card_expiry_mli_formatted,
            :checkin_date => checkin_date,
            :checkout_date => checkout_date,
            :amount => amount,
            :sequence_number => @credit_card_transaction.class.get_sequence_number,
            :hotel_id => @hotel.id,
            :mli_token => @credit_card.mli_token
          })
          
          response = make_request('/LTV/CREDITAUTH', message.to_xml)
          update_auth_transaction(response)
          return @credit_card_transaction
        end
        
        def topup(amount)
          message = Lodging::Message::topup_message({
            :company_code => @company_code,
            :site_code    => @site_code,
            :amount => amount,
            :sequence_number => @credit_card_transaction.class.get_sequence_number,
            :hotel_id => @hotel.id,
            :auth_transaction_id => @credit_card_transaction.external_transaction_ref
          })
          
          response = make_request('/LTV/CREDITAUTH', message.to_xml)
          update_transaction(response, (amount + @credit_card_transaction.amount))
          
          return @credit_card_transaction
        end
        
        def reverse_auth(amount)
          message = Lodging::Message::auth_reverse_message({
            :company_code => @company_code,
            :site_code    => @site_code,
            :amount => amount,
            :sequence_number => @credit_card_transaction.class.get_sequence_number,
            :hotel_id => @hotel.id,
            :auth_transaction_id => @credit_card_transaction.external_transaction_ref
          })
          
          response = make_request('/LTV/CREDITAUTH', message.to_xml)
          update_transaction(response, amount)
          
          return @credit_card_transaction
        end
        
        def update_auth_transaction(response)
          mli_transaction_id = response.at_xpath('/LTV//MLT').text
          # We are storing MLTD in external_transaction_ref
          @credit_card_transaction.update_attributes!(
            :status => true,
            :authorization_code => response.at_xpath('/LTV//AC').text,
            :external_message   => response.at_xpath('/LTV//RT').text,
            :external_transaction_ref => mli_transaction_id,
            :req_reference_no =>  mli_transaction_id
          )
        end
        
        def update_transaction(response, amount)
          @credit_card_transaction.update_attributes!(
            :status => true,
            :amount => amount,
            :authorization_code => response.at_xpath('/LTV//AC').text,
            :external_message   => response.at_xpath('/LTV//RT').text,
            :req_reference_no   => response.at_xpath('/LTV//MLT').text
          )
        end
        
      end
    end
  end
end