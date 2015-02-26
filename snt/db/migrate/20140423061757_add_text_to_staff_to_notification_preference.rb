class AddTextToStaffToNotificationPreference < ActiveRecord::Migration
  def change
    add_column :user_notification_preferences, :alert_text_to_staff, :boolean,:default=>true
    
  end
end
