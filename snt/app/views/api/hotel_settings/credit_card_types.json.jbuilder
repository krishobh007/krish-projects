@result = @credit_card_types + @payment_types_marked_as_is_cc

json.array! @result do |credit_card_type|
  json.call(credit_card_type, :id, :value, :description)
end
