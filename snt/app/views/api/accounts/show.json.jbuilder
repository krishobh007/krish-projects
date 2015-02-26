json.address_details do
	json.street1 @account.andand.address.andand.street1.to_s
	json.street2 @account.andand.address.andand.street2.to_s
	json.street3 @account.andand.address.andand.street3.to_s
	json.city @account.andand.address.andand.city.to_s
	json.state @account.andand.address.andand.state.to_s
	json.postal_code @account.andand.address.andand.postal_code.to_s
	json.country_id @account.andand.address.andand.country_id
	json.email_address @account.emails.first.andand.value
	json.phone @account.phones.first.andand.value
end


json.account_details do
    json.account_name @account.account_name.to_s
    json.company_logo @account.andand.logo.andand.image.andand.url(:thumb).to_s
    json.account_number @account.account_number
	json.accounts_receivable_number  @account.ar_detail.andand.ar_number
	json.billing_information @account.billing_information
	json.routes_count @account.default_account_routings.count
end

json.primary_contact_details do
	json.contact_first_name @account.contact_first_name.to_s
	json.contact_last_name @account.contact_last_name.to_s
	json.contact_job_title @account.contact_job_title.to_s
	json.contact_phone @account.contact_phone.to_s
	json.contact_email @account.contact_email.to_s
end

json.alert_message @account.alert_message
