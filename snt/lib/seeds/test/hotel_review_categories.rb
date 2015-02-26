module SeedTestHotelReviewCategories
  def create_test_hotel_review_categories
    hotel = Hotel.find_by_code('DOZERQA')
    hotel.review_categories = Ref::ReviewCategory.all
  end
end
