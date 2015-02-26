json.accounts @accounts do |account|
  
  json.id account.id
  json.account_name account.account_name
  json.company_logo account.andand.logo.andand.image.andand.url(:thumb).to_s
  json.account_type account.account_type.to_s

  address = account.address
  json.address do
    if address
      json.city address.city
      json.state address.state
    else
      json.null!
    end
  end

  phone = account.phones.first
  json.phone phone.andand.value

  email = account.emails.first
  json.email email.andand.value

  rate = current_contract(account)

  json.current_contract do
    if rate
      json.id rate.id
      json.name rate.rate_name
      json.based_on do
        json.id rate.based_on_rate_id
        json.name rate.based_on_rate.andand.rate_name
        json.value rate.based_on_value
        json.type rate.based_on_type
      end
    else
      json.null!
    end
  end
  
end
