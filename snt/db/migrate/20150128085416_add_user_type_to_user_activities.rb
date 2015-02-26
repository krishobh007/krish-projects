class AddUserTypeToUserActivities < ActiveRecord::Migration
  def change
    add_column :user_activities, :user_type, :string
  end
end
