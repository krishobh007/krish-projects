class AddDefaultValueToNotificationPreferences < ActiveRecord::Migration
  def change
    change_column :user_notification_preferences, :new_post, :boolean, default: true
    change_column :user_notification_preferences, :response_to_post, :boolean, default: true
    change_column :user_notification_preferences, :response_to_review, :boolean, default: true
  end
end
