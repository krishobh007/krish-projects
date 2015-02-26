json.deposit_amount ('%.2f' % @deposit_amount).to_s 

if @deposit_policy
  json.deposit_policy do 
    json.amount @deposit_policy.amount
    json.amount_type @deposit_policy.amount_type
    json.description @deposit_policy.description
    json.id @deposit_policy.id
    json.name @deposit_policy.name
    json.post_type @deposit_policy.post_type.andand.value
    json.allow_deposit_edit @deposit_policy.allow_deposit_edit
  end
end
if @payment_method.present?
  json.attached_card do
    json.value @payment_method.id
    json.card_code @payment_method.andand.credit_card? ? @payment_method.andand.credit_card_type.andand.value : ''
    json.ending_with @payment_method.andand.credit_card? ? @payment_method.andand.mli_token_display.to_s : ''
    json.expiry_date @payment_method.andand.credit_card? ? @payment_method.andand.card_expiry_display.to_s : ''
    json.holder_name @payment_method.andand.credit_card? ? @payment_method.andand.card_name : ''
    json.is_credit_card @payment_method.andand.credit_card?
    json.fees_information @payment_method.andand.fees_information(current_hotel)
  end
end
json.is_hourly @is_hourly