class AddUserStampsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :creator_id, :integer
    add_column :reviews, :updater_id, :integer
  end
end
