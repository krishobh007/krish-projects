class RenameUserTypeIdAndActivityTypeIdInUserActivities < ActiveRecord::Migration
  def change
    rename_column :user_activities, :user_type_id, :application_id
    rename_column :user_activities, :activity_type_id, :action_type_id
  end
end
