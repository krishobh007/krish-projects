module SixPayment
  module ThreeCIntegra
    module Processor
      class Cancel
        
        def initialize(hotel, credit_card)
          @credit_card = credit_card
          @hotel = hotel
        end
        
        def process(attributes)
          @credit_card_transaction = @credit_card.credit_card_transactions.last
          cancel
        end
        
        private
        
        def cancel
          request_obj = Request::Cancel.new(
            :sequence_number            => @credit_card_transaction.class.get_sequence_number,
            :requester_location_id      => @hotel.settings.six_server_location_id,
            :sequence_number_to_cancel  => @credit_card_transaction.sequence_number
          )
          cancel_response = call_end_point(request_obj)
          if cancel_response.result == 'A'
            puts "Cancel is success"
          end
          @credit_card_transaction
        end
        
        def call_authorize_end_point(request_body)
          dummy_output = File.open("#{Rails.root}/tmp/test_files/Cancel.xml")
          SixPayment::ThreeCIntegra::Response::Cancel.new(dummy_output)
        end
        
        def call_end_point(request_body)
          SixPayment::ThreeCIntegra::Connector::Syncronous::Message.new(request_body.to_xml, @hotel).response
        end
      end
    end
  end
end