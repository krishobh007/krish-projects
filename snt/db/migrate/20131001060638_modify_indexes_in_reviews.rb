class ModifyIndexesInReviews < ActiveRecord::Migration
  def change
    rename_index :reviews, :reviewer_id, :reservarion_id
    remove_index :reviews, [:reviewer_id, :reviewer_type]
    remove_index :reviews, [:reviewable_id, :reviewable_type]
  end
end
