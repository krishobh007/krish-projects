module SixPayment
  module ThreeCIntegra
    module Request
      
      class EftAuthorizationEmv < BaseRequest
               
        class Child
          attr_accessor :amount, :eft_authorization_type, :emv_scenario_id, :emv_terminal_id, :time_stamp, :token,
                        :card_input_method, :currency, :card_number
          
          def initialize(attributes)
            @amount = attributes[:amount]
            @eft_authorization_type = attributes[:eft_authorization_type]
            @emv_scenario_id = attributes[:emv_scenario_id] if attributes[:emv_scenario_id]
            @token  = attributes[:token] if attributes[:token]
            @card_input_method = attributes[:card_input_method] if attributes[:card_input_method] 
            @currency = attributes[:currency] if attributes[:currency]
            @card_number = attributes[:card_number] if attributes[:card_number]
            @bank_auth_code = attributes[:bank_auth_code] if attributes[:bank_auth_code]
            @emv_terminal_id        = attributes[:emv_terminal_id] if attributes[:emv_terminal_id]
            @time_stamp = Time.now.strftime("%Y%m%d%H%M%S")
          end
        end
      end
    end
  end
end