

module SixPayment
  module ThreeCIntegra
    module PaymentProcessor
      
      def self.start
        puts "Starting Six Payment Server"
        # Starting rover queue
        RoverQueue.start
        
        EventMachine.run {
          self.process_queue.subscribe do |delivery_info, metadata, payload|
            begin
              puts "Received #{payload}"
              
              process = proc {
                async_callback = AsyncCallback.find(payload)
                if async_callback.origin == Ref::CreditCardTransactionType[:TOKEN]
                  out_put_response = self.get_token(async_callback)
                  async_callback.response = {
                    :token => out_put_response.token,
                    :card_no_last4 => out_put_response.token.split(//).last(4).join("").to_s,
                    :card_type => out_put_response.card_scheme_id,
                    :expiry_date => out_put_response.card_expiry_date
                  }
                end
                async_callback
              }
              
              callback = proc {|result|
                result.save
              }
              
              EventMachine.defer(process, callback)
            rescue Exception => ex
              puts "Exception found -----------------> #{Time.now}"
              puts ex.backtrace
              puts ex.message
            end
            
            puts "-----------------------------------------------------------------------------"
          end
        }
      end
      
      def self.process_queue
        RoverQueue.queue("six_payment_queue")
      end
      
      def self.get_token(async_callback)
        hotel_id = async_callback.request[:hotel_id]
        hotel = Hotel.find(hotel_id)
        
        auth_request = SixPayment::ThreeCIntegra::Processor::Authorize.new(hotel, nil)
        connector = auth_request.process({
          :amount => 0,
          :currency_code => 'GBP',
          :type => 'pre_auth_terminal'
        })
        out_put_response = connector.response
        
        return out_put_response
      end
    end
  end
end