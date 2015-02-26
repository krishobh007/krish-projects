module SixPayment
  module Web2Pay
    module Token
      module Response
        class CheckToken < BaseResponse
          attr_accessor :token_no, :token_masked_no, :token_expiry_yymm, :token_profile_id, :card_type_code, :card_no, 
                :card_masked_no, :card_bin_no, :card_last4_no, :card_expiry_yymm, :card_issue_yymm, :card_issue_no, 
                :card_holder_forename, :card_holder_surname, :card_holder_street, :card_holder_city, :card_holder_state, 
                :card_holder_post_code, :user_ref, :user_data1, :user_data2, :active, :return_text, :return_code
        end
      end
    end
  end
end