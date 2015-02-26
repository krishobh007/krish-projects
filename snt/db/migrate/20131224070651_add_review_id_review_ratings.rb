class AddReviewIdReviewRatings < ActiveRecord::Migration
  def change
    add_column :review_ratings, :review_id, :integer,  references: :reviews
   end
end
