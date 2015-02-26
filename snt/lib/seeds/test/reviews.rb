module SeedReviews
  def create_reviews
    Review.create(description: 'Sample Review 1', title: 'Test1' , reservation_id: 5459)
    Review.create(description: 'Sample Review 2', title: 'Test2' , reservation_id: 2821)
  end
end
