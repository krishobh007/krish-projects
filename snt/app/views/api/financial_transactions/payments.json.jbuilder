total_payment = 0.0

json.payment_types @payment_methods do |payment_type|
  json.id payment_type.id
  json.payment_type payment_type.description
  payment_type_total = 0.0

  if payment_type.value == 'CC'
    json.charge_code ""
    total_number = 0

    json.credit_cards @credit_cards do |card|
      json.credit_card card.description
      charge_code = @cc_charge_codes.find { |charge_code| charge_code.associated_payment_id == card.id }

      if charge_code
        json.charge_code charge_code.charge_code
        transactions = @cc_transactions.select { |transaction| transaction.charge_code_id == charge_code.id }
        json.number transactions.count
        total_number = total_number + transactions.count
        json.partial! 'transactions', transactions: transactions, tran_type: 'payment'
        amount = transactions.sum(&:amount)
      else
        json.charge_code ""
        json.number ""
        json.partial! 'transactions', transactions: [], tran_type: 'payment'
        amount = 0.00
      end

      json.amount amount
      total_payment = total_payment + amount
    end

    json.number total_number
  else
    charge_code = @non_cc_charge_codes.find { |charge_code| charge_code.associated_payment_id == payment_type.id }

    if charge_code
      json.charge_code charge_code.charge_code
      transactions = @non_cc_transactions.select { |transaction| transaction.charge_code_id == charge_code.id }
      json.number transactions.count
      json.partial! 'transactions', transactions: transactions, tran_type: 'payment'
      amount = transactions.sum(&:amount)
    else
      json.charge_code ""
      json.number ""
      json.partial! 'transactions', transactions: [], tran_type: 'payment'
      amount = 0.00
    end

    json.amount amount
    total_payment = total_payment + amount
  end
end

json.total_payment total_payment
