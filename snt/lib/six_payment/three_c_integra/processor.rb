module SixPayment
  module ThreeCIntegra
    module Processor
      def process_authorize(attributes)
        @credit_card_transaction = Authorize.new(current_hotel, @payment_method).process(attributes)
      end
      
      def process_sale(attributes)
        attributes[:type] = 'sale'
        @credit_card_transaction = Settlement.new(current_hotel, @payment_method).process(attributes)
      end
      
      def process_completion(attributes)
        attributes[:type] = 'completion'
        @credit_card_transaction = Settlement.new(current_hotel, @payment_method).process(attributes)
      end
      
      def process_refund(attributes)
        attributes[:type] = 'refund'
        @credit_card_transaction = Settlement.new(current_hotel, @payment_method).process(attributes)
      end
      
      def process_reversal(attributes)
        type = attributes[:type]
        if type == "pre_auth_reversal"
          @credit_card_transaction = Authorize.new(current_hotel, @payment_method).process(attributes)
        elsif type == 'topup_reversal'
          @credit_card_transaction = Authorize.new(current_hotel, @payment_method).process(attributes)
        elsif type == 'settle_reversal'
          @credit_card_transaction = Settlement.new(current_hotel, @payment_method).process(attributes)
        elsif type == 'auth_settle_reversal'
          @credit_card_transaction = Settlement.new(current_hotel, @payment_method).process(attributes)
        end
      end
      
      def process_cancel(attributes)
        @credit_card_transaction = Cancel.new(current_hotel, @payment_method).process(attributes)
      end
      
      def process_check_status(attributes)
        CheckStatus.new(@work_station).process
      end
      
      def process_get_token(attributes)
        # @async_callback = AsyncCallback.create(
          # :origin   => Ref::CreditCardTransactionType[:TOKEN],
          # :request => {:hotel_id => current_hotel.id},
          # :response => {}
        # )
        # RoverQueue.publish("six_payment_queue", "#{@async_callback.id}")
        @out_put_response = Authorize.new(current_hotel, nil).process({
          :amount => 0,
          :currency_code => current_hotel.default_currency.andand.value,
          :type => 'pre_auth_terminal'
        })
      end
    end
  end
end