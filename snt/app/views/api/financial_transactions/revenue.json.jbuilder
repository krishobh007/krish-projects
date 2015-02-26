total_revenue = 0.0

json.charge_groups @charge_groups do |charge_group|
  json.id charge_group.id 
  json.name charge_group.description
  total_number = 0
    
  charge_group_revenue_total = 0.0
  charge_codes = @charge_codes.select { |charge_code| charge_code.charge_group_id == charge_group.id }
  json.charge_codes charge_codes do |charge_code|
    json.id charge_code.id
    json.name charge_code.description
    json.code charge_code.charge_code
    transactions = @transactions.select { |transaction| transaction.charge_code_id == charge_code.id }
    total = transactions.empty? ? 0.0 :  transactions.map{|a| a.amount}.sum
    charge_group_revenue_total += total
    json.total total.round(2)
    number = transactions.count
    json.number number
    total_number = total_number + number
    json.partial! 'transactions', transactions: transactions, tran_type: 'revenue'
  end
  total = charge_group_revenue_total.round(2)
  json.number total_number
  json.total total
  total_revenue += total
end
json.total_revenue total_revenue