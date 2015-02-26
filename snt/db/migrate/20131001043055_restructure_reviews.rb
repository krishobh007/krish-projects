class RestructureReviews < ActiveRecord::Migration
  def change
    rename_column :reviews, :reviewable_id, :review_category_id
    rename_column :reviews, :reviewer_id, :reservation_id
    remove_column :reviews, :reviewable_type
    remove_column :reviews, :reviewer_type
  end
end
