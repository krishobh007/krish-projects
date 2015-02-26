class AddIndexToUserActivities < ActiveRecord::Migration
  def change
    add_index :user_activities, [:hotel_id, :application_id], name: 'index_user_activities_on_hotel_id_and_application_id'
    add_index :user_activities, [:hotel_id, :associated_activity_id], name: 'index_user_activities_on_hotel_id_and_associated_activity_id'
    add_index :user_activities, [:associated_activity_id, :associated_activity_type], name: 'index_user_activities_on_associated_activity'
  end
end
