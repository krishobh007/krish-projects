class ChangeUserIdNameInUserActivities < ActiveRecord::Migration
  def change
    rename_column :user_activities, :user_id, :associated_activity_id
    rename_column :user_activities, :user_type, :associated_activity_type
  end
end
