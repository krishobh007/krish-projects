module SeedTestHotelBrands
  def create_test_hotel_brands
    hotel_chain = HotelChain.first

    HotelBrand.create(name: 'Brand One', hotel_chain: hotel_chain)
    HotelBrand.create(name: 'Brand Two', hotel_chain: hotel_chain)
  end
end
