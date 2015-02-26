module SixPayment
  module ThreeCIntegra
    class ThreeCIntegraConfigurationError < StandardError; end
    
    class ThreeCIntegraInvalidParameters < StandardError; end
    
    class ThreeCIntegraSettlementError < StandardError; end
  end
end