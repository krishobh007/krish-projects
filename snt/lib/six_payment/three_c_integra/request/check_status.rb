module SixPayment
  module ThreeCIntegra
    module Request
      
      class CheckStatus < Base
        
        def initialize(attributes)
          @children = Children.new(attributes)
        end
        
        class Children
          attr_accessor :amount, :eft_authorization_type, :emv_scenario_id, :emv_terminal_id, :time_stamp
          
          def initialize(attributes)
            @amount = attributes[:amount]
            @eft_authorization_type = attributes[:eft_authorization_type]
            @emv_scenario_id = attributes[:emv_scenario_id]
            @emv_terminal_id = attributes[:emv_terminal_id]
            @time_stamp = Time.now.to_i
          end
          
        end
      end
    end
  end
end