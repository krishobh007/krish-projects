class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.integer :hotel_id, null: false
      t.integer :user_id, null: false
      t.string :user_type, null: false
      t.string :activity_type, null: false
      t.string :activity_status, null: false
      t.string :message
      t.string :user_ip_address, null: false
      t.timestamps
    end
  end
end
