module SixPayment
  module ThreeCIntegra
    module Request
      
      class EftSettlementEmv < BaseRequest
        
        class Child
          attr_accessor :amount, :eft_settlement_type, :auth_code_input_method, :bank_auth_code, :emv_scenario_id, :token, 
                        :emv_terminal_id, :time_stamp, :currency, :amount_total
          
          def initialize(attributes)
            @amount                 = attributes[:amount]
            @amount_total           = attributes[:amount]
            @bank_auth_code         = attributes[:bank_auth_code] if attributes[:bank_auth_code]
            @eft_settlement_type    = attributes[:eft_settlement_type]
            @token                  = attributes[:token] if attributes[:token]
            @card_number            = attributes[:card_number] if attributes[:card_number]
            @card_input_method      = attributes[:card_input_method] if attributes[:card_input_method]
            @currency               = attributes[:currency]
            @emv_scenario_id        = attributes[:emv_scenario_id] if attributes[:emv_scenario_id]
            @emv_terminal_id        = attributes[:emv_terminal_id] if attributes[:emv_terminal_id]
            @auth_code_input_method = 'A'
            @time_stamp             = Time.now.strftime("%Y%m%d%H%M%S")
          end
          
        end
      end
      
      
    end
  end
end