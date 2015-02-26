# Maps the payment type parameters to match model
class ViewMappings::PaymentTypeMapping

  def self.map_payment_type(params)
    attributes = {
      payment_type: params[:payment_type],
      credit_card_type: params[:credit_card],
      card_name: params[:card_name],
      card_expiry: params[:card_expiry],
      bill_number: params.key?(:bill_number) ?  params[:bill_number] : 1
    }

    attributes[:card_number] = params[:card_number] if params.key?(:card_number)
    attributes[:card_expiry] = params[:card_expiry] if params.key?(:card_expiry)

    if params.key?(:mli_token)
      attributes[:mli_token] = params[:mli_token]
      attributes[:et2] = params[:et2]
      attributes[:etb] = params[:etb]
      attributes[:ksn] = params[:ksn]
      attributes[:pan] = params[:pan]
    end
    
    attributes[:is_encrypted] = params[:is_encrypted] if params.key?(:is_encrypted)
    attributes[:token] = params[:token] if params.key?(:token)
    attributes[:id] = params[:id] if params.key?(:id)
    attributes[:is_from_guest_card] = params[:is_from_guest_card] if params.key?(:is_from_guest_card)
    attributes[:is_from_bill] = params[:is_from_bill] if params.key?(:is_from_bill)


    attributes
  end

end
