module SeedContractNight
  def create_contract_nights
    rate = Rate.first

    rate.contract_nights.create(month_year: '2014-01-01', no_of_nights: 10)
    rate.contract_nights.create(month_year: '2014-02-01', no_of_nights: 10)
    rate.contract_nights.create(month_year: '2014-03-01', no_of_nights: 10)
    rate.contract_nights.create(month_year: '2014-04-01', no_of_nights: 10)
  end
end
