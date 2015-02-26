json.array! @payment_types do |payment_type|
  json.id payment_type.id
  json.value payment_type.value
  json.description payment_type.description
  
  hotel_payment_type = HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => payment_type.id).first
  json.is_display_reference hotel_payment_type.andand.is_display_reference
  
  json.charge_code do 
  	charge_code = payment_type.charge_code(current_hotel)
	unless charge_code.nil?
	  json.id  charge_code.id
	  json.fees_information charge_code.fees_information
	end
  end
  
  value_list = payment_type.credit_card? ? PaymentType.activated_credit_card(current_hotel) + current_hotel.credit_card_types : []
  
  json.credit_card_list value_list.each do |each_value|
  	json.id each_value.id
	json.cardname each_value.description
	json.cardcode each_value.value
        
    hotel_credit_card_type = each_value.is_a?(PaymentType) ? 
                HotelsPaymentType.where(:hotel_id => current_hotel.id, :payment_type_id => each_value.id).first : 
                HotelsCreditCardType.where(:hotel_id => current_hotel.id, :ref_credit_card_type_id => each_value.id).first
                
    json.is_display_reference hotel_credit_card_type.andand.is_display_reference
    
    json.charge_code do 
  		charge_code = each_value.charge_code(current_hotel)
		unless charge_code.nil?
		  json.id  charge_code.id
		  json.fees_information charge_code.fees_information
		end
  	end
  end
end
