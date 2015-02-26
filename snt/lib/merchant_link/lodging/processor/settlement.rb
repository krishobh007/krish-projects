module MerchantLink
  module Lodging
    module Processor
      class Settlement < Mli
        include Connector
        
        def process(attributes = {})
          @credit_card  = attributes[:payment_method]
          amount        = attributes[:amount]
          checkin_date  = attributes[:checkin_date]
          checkout_date = attributes[:checkout_date] 
          room_rate     = attributes[:room_rate] 
          guest_name    = attributes[:guest_name]  
          type          = attributes[:type]
          
          if type == 'settle'
            @credit_card_transaction = @credit_card.credit_card_transactions
                              .where("credit_card_transaction_type_id = ? OR credit_card_transaction_type_id = ?", Ref::CreditCardTransactionType[:AUTHORIZATION].id, Ref::CreditCardTransactionType[:TOPUP].id)
                              .last
            
            settle(amount, checkin_date, checkout_date, room_rate, guest_name)
          elsif type == 'auth_settle'
            auth_attributes = attributes
            auth_attributes[:type]  = 'pre_auth'
            @credit_card_transaction = Authorize.new(@hotel).process(auth_attributes)
            
            settle(amount, checkin_date, checkout_date, room_rate, guest_name)
          end
        end
        
        private 
        
        def settle(amount, checkin_date, checkout_date, room_rate, guest_name)
          message = Lodging::Message::settle_message({
            :auth_transaction_id => @credit_card_transaction.external_transaction_ref,
            :company_code     => @company_code,
            :site_code        => @site_code,
            :arrival_date     => checkin_date,
            :departure_date   => checkout_date,
            :authorize_amount => @credit_card_transaction.amount,
            :settle_amount    => amount,
            :room_rate        => room_rate,
            :sequence_number  => @credit_card_transaction.class.get_sequence_number,
            :hotel_id         => @hotel.id,
            :guest_name       => guest_name
          })
          
          response = make_request('/LTV/CREDITSETTLE', message.to_xml)
          update_settle_transaction(response)
          
          return @credit_card_transaction
        end
        
        def update_settle_transaction(response)
          @credit_card_transaction.update_attributes!(
            :req_reference_no => response.at_xpath('/LTV//MLT').text,
            :external_message => response.at_xpath('/LTV//RC').text,
            :credit_card_transaction_type => Ref::CreditCardTransactionType[:SETTLEMENT]
          )
        end
      end
    end
  end
end