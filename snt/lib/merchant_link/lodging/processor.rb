module MerchantLink
  module Lodging
    module Processor
      
      def process_authorize(attributes)
        authorize = Authorize.new(current_hotel)
        attributes[:payment_method] = @payment_method
        @credit_card_transaction = authorize.process(attributes)
      end
      
      def process_completion(attributes)
        settlement = Settlement.new(current_hotel)
        attributes[:payment_method] = @payment_method
        attributes[:type] = 'settle'
        @credit_card_transaction = settlement.process(attributes)
      end
      
      def process_refund(attributes)
        refund = Refund.new(current_hotel)
        attributes[:payment_method] = @payment_method
        @credit_card_transaction = refund.process(attributes)
      end
      
      def process_sale(attributes)
        settlement = Settlement.new(current_hotel)
        attributes[:payment_method] = @payment_method
        attributes[:type] = 'auth_settle'
        @credit_card_transaction = settlement.process(attributes)
      end
      
      def process_reversal(attributes)
        authorize = Authorize.new(current_hotel)
        attributes[:payment_method] = @payment_method
        @credit_card_transaction = authorize.process(attributes)
      end
    end
  end
end