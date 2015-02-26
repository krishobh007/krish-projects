class RemoveReservationIdFromReviewRatings < ActiveRecord::Migration
  def up
    remove_column :review_ratings, :reservation_id
  end

  def down
    add_column :review_ratings, :reservation_id, :integer
  end
end
