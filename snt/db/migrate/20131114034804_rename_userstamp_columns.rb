class RenameUserstampColumns < ActiveRecord::Migration
  def change
    rename_column :admin_menu_options, :created_by_id, :creator_id
    rename_column :admin_menu_options, :updated_by_id, :updater_id
    rename_column :admin_menus, :created_by_id, :creator_id
    rename_column :admin_menus, :updated_by_id, :updater_id
    rename_column :membership_types, :created_by_id, :creator_id
    rename_column :membership_types, :updated_by_id, :updater_id
    rename_column :payment_types, :created_by_id, :creator_id
    rename_column :payment_types, :updated_by_id, :updater_id
    rename_column :preferences, :created_by_id, :creator_id
    rename_column :preferences, :updated_by_id, :updater_id
    rename_column :rates, :created_by_id, :creator_id
    rename_column :rates, :updated_by_id, :updater_id
    rename_column :reservation_notes, :created_by_id, :creator_id
    rename_column :reservation_notes, :updated_by_id, :updater_id
    rename_column :reservation_payment_types, :created_by_id, :creator_id
    rename_column :reservation_payment_types, :updated_by_id, :updater_id
    rename_column :room_features, :created_by_id, :creator_id
    rename_column :room_features, :updated_by_id, :updater_id
    rename_column :rooms, :created_by_id, :creator_id
    rename_column :rooms, :updated_by_id, :updater_id
    rename_column :room_types, :created_by_id, :creator_id
    rename_column :room_types, :updated_by_id, :updater_id
    rename_column :url_mappings, :created_by_id, :creator_id
    rename_column :url_mappings, :updated_by_id, :updater_id
    rename_column :user_memberships, :created_by_id, :creator_id
    rename_column :user_memberships, :updated_by_id, :updater_id
    rename_column :user_payment_types, :created_by_id, :creator_id
    rename_column :user_payment_types, :updated_by_id, :updater_id
    rename_column :user_preferences, :created_by_id, :creator_id
    rename_column :user_preferences, :updated_by_id, :updater_id
    rename_column :wakeups, :created_by_id, :creator_id
    rename_column :wakeups, :updated_by_id, :updater_id
  end
end
