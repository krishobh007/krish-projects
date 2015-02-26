class AddIndexesForSearch < ActiveRecord::Migration
  def change
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :reservations, :confirm_no
    add_index :reservations, :arrival_date
    add_index :groups, :name
    add_index :reservation_daily_instances, :group_id
    add_index :reservation_daily_instances, :room_id
    add_index :reservation_daily_instances, :room_type_id
    add_index :reservation_daily_instances, :rate_id
    add_index :reservation_daily_instances, :reservation_date
    add_index :user_addresses, :user_id
    add_index :user_contacts, :user_id
  end
end
