json.id @rate.id
json.total_contracted_nights @rate.contract_nights.sum(:no_of_nights)
