module SixPayment
  module ThreeCIntegra
    module Request
      
      class EftTerminalStatus < BaseRequest
        
        class Child
          attr_accessor :status_type, :time_stamp, :data, :emv_scenario_id
          
          def initialize(attributes)
            @status_type = attributes[:status_type]
            @emv_scenario_id = "DU"
            @time_stamp = Time.now.to_i
          end
        end
      end
    end
  end
end