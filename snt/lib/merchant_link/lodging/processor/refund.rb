module MerchantLink
  module Lodging
    module Processor
      class Refund < Mli
        include Connector
        
        def process(attributes = {})
          @credit_card  = attributes[:payment_method]
          amount        = attributes[:amount]
          
          raise InvalidParameterError, "The authorize amount should be less than $1" unless (amount.present? && (amount && amount.to_i <= -1))
          
          guest_name    = attributes[:guest_name]  
            
          @credit_card_transaction = CreditCardTransaction.create(
            :hotel => @hotel,
            :amount => amount,
            :credit_card_transaction_type => Ref::CreditCardTransactionType[:AUTHORIZATION],
            :status => false,
            :payment_method => @credit_card,
            :sequence_number => 0
          )
          
          refund(amount, guest_name)
        end
        
        private 
        
        def refund(amount, guest_name)
          message = Lodging::Message::refund_message({
            :auth_transaction_id => @credit_card_transaction.external_transaction_ref,
            :company_code     => @company_code,
            :site_code        => @site_code,
            :hotel_id         => @hotel.id,
            :expiry_date      => @credit_card.card_expiry_mli_formatted,
            :arrival_date     => Time.now.strftime('%Y%m%d'),
            :departure_date   => Time.now.strftime('%Y%m%d'),
            :amount           => amount,
            :mli_token        => @credit_card.mli_token,
            :sequence_number  => @credit_card_transaction.class.get_sequence_number,
            :hotel_id         => @hotel.id,
            :guest_name       => guest_name
          })
          
          response = make_request('/LTV/CREDITSETTLE', message.to_xml)
          update_refund_transaction(response)
          
          return @credit_card_transaction
        end
        
        def update_refund_transaction(response)
          @credit_card_transaction.update_attributes!(
            :req_reference_no => response.at_xpath('/LTV//MLT').text,
            :external_transaction_ref => response.at_xpath('/LTV//MLT').text,
            :authorization_code => response.at_xpath('/LTV//CK').text,
            :external_message => response.at_xpath('/LTV//RC').text,
          )
        end
      end
    end
  end
end