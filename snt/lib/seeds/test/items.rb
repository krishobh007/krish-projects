module SeedTestItems
  def create_test_items
    hotel = Hotel.first
    charge_code = ChargeCode.first
    articles = ['Band Aid', 'Jack Daniels', 'Seltzer Water', 'Ginger Ale', 'Evian 2L', 'Spring Water', 'Apple 1Kg', 'Oranges 1Kg', 'Duff Beer 50cl']
    articles.each do |item|
      Item.create(charge_code_id: charge_code.id, description: item, hotel_id: hotel.id, unit_price: 100.00, is_favorite: true)
    end
  end
end
