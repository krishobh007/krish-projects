json.current_contracts @current_contracts do |contract|
  json.id contract.id
  json.contract_name contract.rate_name
end

json.future_contracts @future_contracts do |contract|
  json.id contract.id
  json.contract_name contract.rate_name
end

json.history_contracts @history_contracts do |contract|
  json.id contract.id
  json.contract_name contract.rate_name
end

if @current_contracts && @current_contracts.count > 0
  json.contract_selected @current_contracts.first.id
elsif @future_contracts && @future_contracts.count > 0
  json.contract_selected @future_contracts.first.id
elsif @history_contracts && @history_contracts.count > 0
  json.contract_selected @history_contracts.first.id
end
