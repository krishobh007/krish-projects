class ChangeReviewDescriptionSize < ActiveRecord::Migration
  def change
    change_column :reviews, :description, :string, limit: 500
  end
end
