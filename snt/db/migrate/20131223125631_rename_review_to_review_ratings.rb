class RenameReviewToReviewRatings < ActiveRecord::Migration
  def change
    rename_table :reviews, :review_ratings
    end
end
