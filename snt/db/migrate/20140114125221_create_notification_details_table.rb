class CreateNotificationDetailsTable < ActiveRecord::Migration
  def change
    create_table :notification_details do |t|
      t.integer :id
      t.integer :notification_id
      t.string :notification_type
      t.string :message
      t.string :additional_data

      t.timestamps
    end
  end
end
