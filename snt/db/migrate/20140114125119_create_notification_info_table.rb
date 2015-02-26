class CreateNotificationInfoTable < ActiveRecord::Migration
  def change
    create_table :notification_info do |t|
      t.integer :id
      t.integer :user_id , references: :users
      t.string :unique_id
      t.string :registration_id
      t.string :device_type

      t.timestamps
    end
  end
end
