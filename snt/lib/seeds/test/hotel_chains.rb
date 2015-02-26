module SeedTestHotelChains
  def create_test_hotel_chains
    HotelChain.create(name: 'Chain One', code: 'CHA', domain_name: 'cha.stayntouch.com')
    HotelChain.create(name: 'Chain Two', code: 'TWO')
    HotelChain.create(name: 'Admin Chain', code: 'ADMIN')
  end
end
