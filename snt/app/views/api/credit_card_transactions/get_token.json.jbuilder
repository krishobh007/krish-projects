
if @async_callback.present?
	json.call_back_url api_async_callback_path(@async_callback)
end

if @out_put_response.present?
	json.token @out_put_response.token
	json.ending_with @out_put_response.token.split(//).last(4).join("").to_s
	json.card_type @out_put_response.card_scheme_id
	json.expiry_date @out_put_response.card_expiry_date
end

if @payment_method.present?
	json.payment_method_id @payment_method.id
end

if @guest_payment_method.present?
	json.guest_payment_method_id @guest_payment_method.id
end