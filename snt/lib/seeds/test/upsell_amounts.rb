module SeedTestUpsellAmounts
  def create_test_upsell_amounts
    UpsellAmount.create(
    level_from: 1,
    level_to: 2,
    amount: 100,
    hotel_id: Hotel.first.id
    )
    UpsellAmount.create(
    level_from: 1,
    level_to: 3,
    amount: 300,
    hotel_id: Hotel.first.id
    )
    UpsellAmount.create(
    level_from: 2,
    level_to: 3,
    amount: 150,
    hotel_id: Hotel.first.id
    )
  end
end
