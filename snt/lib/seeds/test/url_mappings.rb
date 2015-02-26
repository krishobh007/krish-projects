module SeedTestURLMappings
  def create_test_url_mappings
    hotel = Hotel.first
    hotel_chain_id = hotel.hotel_chain.id

    # Mappings for URLS
    UrlMapping.create(url: 'http://dozerqa.stayntouch.com/', hotel_chain_id: hotel_chain_id)
    UrlMapping.create(url: 'http://cha.stayntouch.com/', hotel_chain_id: hotel_chain_id)
    UrlMapping.create(url: 'http://myhotel.stayntouch.com/', hotel_chain_id: hotel_chain_id)
    UrlMapping.create(url: 'http://mychain.stayntouch.com/', hotel_chain_id: hotel_chain_id)
  end
end
