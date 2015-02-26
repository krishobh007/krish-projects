if charge_code
  cc_total = 0.0
  json.charge_code charge_code.charge_code
  transactions = charge_code.financial_transactions.where('date = ?', @date)
  json.number transactions.count
  json.partial! 'transactions', transactions: transactions, tran_type: 'payment'
  amount = transactions.sum(&:amount)
  json.amount amount
  
end
