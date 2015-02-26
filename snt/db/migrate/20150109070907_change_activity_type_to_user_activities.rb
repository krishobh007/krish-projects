class ChangeActivityTypeToUserActivities < ActiveRecord::Migration
  def change
    rename_column :user_activities, :user_type, :user_type_id
    rename_column :user_activities, :activity_type, :activity_type_id
  end
end
