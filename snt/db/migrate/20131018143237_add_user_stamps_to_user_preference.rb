class AddUserStampsToUserPreference < ActiveRecord::Migration
  def change
    add_column :user_preferences, :created_by_id, :integer
    add_column :user_preferences, :updated_by_id, :integer
  end
end
