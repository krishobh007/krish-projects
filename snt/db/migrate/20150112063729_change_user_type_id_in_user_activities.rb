class ChangeUserTypeIdInUserActivities < ActiveRecord::Migration
  def change
    change_column :user_activities, :user_type_id, :integer, null: true
    change_column :user_activities, :activity_type_id, :integer, null: true
  end
end
