class AddNotificationPreferenceForBeacon < ActiveRecord::Migration
  def change
    add_column :user_notification_preferences, :is_alert_promotions , :boolean
  end

end
