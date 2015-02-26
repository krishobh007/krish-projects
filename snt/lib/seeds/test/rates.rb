#rates.rb
module SeedRate
  def create_rate
    hotel = Hotel.first

    hotel.rates.create(rate_desc: 'First Rate', begin_date: Date.today, end_date: Date.today + 1.year,
    	  rate_name: 'First Rate', rate_type_id: RateType.find_by_name('Corporate Rates').id,
    	  charge_code_id: hotel.charge_codes.first.id, currency_code_id: Ref::CurrencyCode.first.id)
  end
end