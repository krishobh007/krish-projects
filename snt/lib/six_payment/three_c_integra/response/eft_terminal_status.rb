module SixPayment
  module ThreeCIntegra
    module Response
      
      class EftTerminalStatus < BaseResponse
        
        attr_accessor :emv_terminal_id, :status_type, :status_message, :status_code, :data2
      end
      
      
    end
  end
end