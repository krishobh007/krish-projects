json.array! @reservation.bills do |bill|
  json.id bill.id
  json.bill_number bill.bill_number
end