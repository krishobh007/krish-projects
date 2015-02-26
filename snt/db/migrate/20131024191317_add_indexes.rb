class AddIndexes < ActiveRecord::Migration
  def change
    add_index :reservation_daily_instances, :reservation_id
    add_index :user_payment_types, :user_id
    add_index :reservation_notes, :reservation_id
    add_index :reservations_preferences, :reservation_id
    add_index :reservations_preferences, :preference_id
    add_index :reservations_memberships, :reservation_id
    add_index :reservations_memberships, :membership_id
    add_index :user_memberships, :user_id
    add_index :wakeups, :reservation_id
  end
end
