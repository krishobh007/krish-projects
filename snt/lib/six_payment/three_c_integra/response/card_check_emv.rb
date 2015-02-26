module SixPayment
  module ThreeCIntegra
    module Response
      
      class CardCheckEmv < BaseResponse
        
        attr_accessor :type, :card_expiry_date, :card_function_id, :card_function_name, :card_input_method, :card_invoice_company_id,
                      :card_invoice_company_name, :card_number, :card_scheme_id, :card_scheme_name
      end
    end
  end
end