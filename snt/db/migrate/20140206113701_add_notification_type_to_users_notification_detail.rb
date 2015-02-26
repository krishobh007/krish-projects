class AddNotificationTypeToUsersNotificationDetail < ActiveRecord::Migration
  def change
    add_column :users_notification_details, :notification_channel, :string
  end
end
