class ChangeAlerttimeFieldFromTimeToDatetimeInUsersNotificationDetailsTable < ActiveRecord::Migration
  def change
    change_column :users_notification_details, :alert_time, :datetime
  end
end
