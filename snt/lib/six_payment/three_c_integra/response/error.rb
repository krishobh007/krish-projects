module SixPayment
  module ThreeCIntegra
    module Response
      
      class Error < BaseResponse
        
        attr_accessor :message, :error_code
      end
    end
  end
end