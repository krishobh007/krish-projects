module SixPayment
  module ThreeCIntegra
    module Processor
      class Token
        
        def initialize(workstation)
          @workstation = workstation
          @hotel = @workstation.hotel
        end
      end
    end
  end
end
        
        