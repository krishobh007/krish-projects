module SixPayment
  module ThreeCIntegra
    module Request
      
      class CardCheckEmv < BaseRequest
        
        class Child
          attr_accessor :type, :card_input_method, :emv_scenario_id, :emv_terminal_id
          def initialize(attributes)
            @type = attributes[:type]
            @card_input_method = attributes[:card_input_method]
            @emv_scenario_id = "DU"
          end
        end
      end
    end
  end
end