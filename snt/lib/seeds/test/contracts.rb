module SeedContract
  def create_contract
    account = Account.first
    rate = RateType.find_by_name('Corporate Rates').rates.first

    account.rates.create(rate_name: 'First Contract', begin_date: '2014-05-01', end_date: '2015-05-01', is_fixed_rate: true,
                         is_rate_shown_on_guest_bill: true, based_on_type: 'percent', based_on_value: -10, based_on_rate_id: rate.id)
  end
end
