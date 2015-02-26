class ReviewRating < ActiveRecord::Base
  attr_accessible :rating, :review_category_id, :review_category

  belongs_to :review, inverse_of: :review_ratings

  has_enumerated :review_category, class_name: 'Ref::ReviewCategory'

  validates :rating, length: { in: 1..5 }
  validates :rating, :review_category_id, :review_id, presence: true
  validates :review_category_id, uniqueness: { scope: :review_id }
end
