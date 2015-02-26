class AddAlertTimeFieldToUsersNotificationTable < ActiveRecord::Migration
  def change
    add_column :users_notification_details, :alert_time, :time
  end
end
