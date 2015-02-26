json.call(@guest_detail, :title, :first_name, :last_name, :job_title, :works_at, :birthday, :is_opted_promotion_email)

json.email @guest_detail.email
json.phone @guest_detail.phone
json.mobile @guest_detail.mobile
json.vip @guest_detail.is_vip

json.address do
	address = @guest_detail.addresses.primary.first

	if address
		json.call(address, :street1, :street2, :city, :state, :postal_code, :country_id)
	else
		json.null!
	end
end
