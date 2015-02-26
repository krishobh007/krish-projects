module SixPayment
  module ThreeCIntegra
    module Request
      class Cancel < BaseRequest

        class Child
          attr_accessor :sequence_number_to_cancel
          def initialize(attributes)
            @sequence_number_to_cancel = attributes[:sequence_number_to_cancel]
          end
        end
        
      end
    end
  end
end