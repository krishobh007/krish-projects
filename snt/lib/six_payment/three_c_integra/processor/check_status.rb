module SixPayment
  module ThreeCIntegra
    module Processor
      class Refund
        def initialize(workstation)
          @workstation = workstation
          @hotel = workstation.hotel
        end
        
        def process
          
        end
      end
    end
  end
end