class RemoveUniqOfUserIdInUserNotificationDetails < ActiveRecord::Migration
  def change
   remove_index :users_notification_details, name: 'index_users_notification_details_uniq'
  end
end
