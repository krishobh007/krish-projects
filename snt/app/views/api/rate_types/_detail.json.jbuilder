json.call(rate_type, :id, :name)
json.rate_count current_hotel.rates.where(rate_type_id: rate_type.id).count
json.activated current_hotel.rate_types.exists?(id: rate_type.id)
json.system_defined rate_type.system_defined?
