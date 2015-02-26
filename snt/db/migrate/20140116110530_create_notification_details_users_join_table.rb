class CreateNotificationDetailsUsersJoinTable < ActiveRecord::Migration
  def change
    create_table :users_notification_details do |t|
      t.integer :user_id, references: :users
      t.integer :notification_detail_id, references: :notification_details
      t.boolean :is_read
      t.boolean :is_pushed
      t.boolean :should_notify

      t.timestamps
    end
  end
end
