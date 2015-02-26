class CreateUserNotificationPreferences < ActiveRecord::Migration
  def change
    create_table :user_notification_preferences do |t|
      t.references :user
      t.boolean :new_post
      t.boolean :response_to_post
      t.boolean :response_to_review
    end
  end
end
