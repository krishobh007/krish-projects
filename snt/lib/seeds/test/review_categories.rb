module SeedTestReviewCategories
  def create_test_review_categories
    Ref::ReviewCategory.enumeration_model_updates_permitted = true
    Ref::ReviewCategory.create(value: 'Location', description: 'Location')
    Ref::ReviewCategory.create(value: 'Sleep Quality', description: 'Sleep Quality')
    Ref::ReviewCategory.create(value: 'Rooms', description: 'Rooms')
    Ref::ReviewCategory.create(value: 'Service', description: 'Service')
    Ref::ReviewCategory.create(value: 'Value', description: 'Value')
    Ref::ReviewCategory.create(value: 'Cleanliness', description: 'Cleanliness')
  end
end
