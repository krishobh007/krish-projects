module SeedRateTypes
  def create_rate_types
    RateType.create(name: 'Rack Rates')
    RateType.create(name: 'Best Available Rates')
    RateType.create(name: 'Corporate Rates')
    RateType.create(name: 'Consortia Rates')
    RateType.create(name: 'Group Rates')
    RateType.create(name: 'Government Rates')
    RateType.create(name: 'Package Rates')
    RateType.create(name: 'Specials & Promotions')
  end
end
