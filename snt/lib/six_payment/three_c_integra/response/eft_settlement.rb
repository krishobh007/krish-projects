module SixPayment
  module ThreeCIntegra
    module Response
      class EftSettlement < BaseResponse
        attr_accessor :amount, :amount_extra, :amount_used, :bank_auth_code, :bank_result_code, :bin_amount, :bin_rate,
                      :card_expiry_date, :card_function_id, :card_function_name, :card_input_method, :card_invoice_company_id,
                      :card_invoice_company_name, :card_number, :card_scheme_id, :card_scheme_name, :currency_used, :dcc_flag,
                      :eft_settlement_type, :local_amount, :merchant_id, :message, :result, :result_reason, :trans_ref_num,
                      :emv_pin_verified, :bank_terminal_id, :signature_required, :token, 
                      :emv_terminal_id, :emv_authorized, :eft_settlement_type
      end
    end
  end
end