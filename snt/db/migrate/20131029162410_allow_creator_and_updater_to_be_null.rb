class AllowCreatorAndUpdaterToBeNull < ActiveRecord::Migration
  def change
    change_column :user_memberships, :created_by_id, :integer, null: true
    change_column :user_memberships, :updated_by_id, :integer, null: true
    change_column :membership_types, :created_by_id, :integer, null: true
    change_column :membership_types, :updated_by_id, :integer, null: true
    change_column :reservation_payment_types, :created_by_id, :integer, null: true
    change_column :reservation_payment_types, :updated_by_id, :integer, null: true
    change_column :room_features, :created_by_id, :integer, null: true
    change_column :room_features, :updated_by_id, :integer, null: true
    change_column :user_payment_types, :created_by_id, :integer, null: true
    change_column :user_payment_types, :updated_by_id, :integer, null: true
    change_column :user_preferences, :created_by_id, :integer, null: true
    change_column :user_preferences, :updated_by_id, :integer, null: true
    change_column :wakeups, :created_by_id, :integer, null: true
    change_column :wakeups, :updated_by_id, :integer, null: true
  end
end
