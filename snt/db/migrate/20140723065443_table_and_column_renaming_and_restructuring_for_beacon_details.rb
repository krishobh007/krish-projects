class TableAndColumnRenamingAndRestructuringForBeaconDetails < ActiveRecord::Migration
  def change
    rename_column :beacon_details, :beacon_uuid, :uuid
    rename_column :beacon_details, :guest_message, :notification_text
    rename_column :beacon_details, :beacon_status, :is_inactive
    rename_column :beacon_details, :promo_detail_id, :promotion_id
    remove_column :beacon_details, :beacon_type
    add_column :beacon_details, :type_id, :integer, null: false
    add_column :beacon_details, :trigger_range_id, :integer, null: false
    rename_table :beacon_details, :beacons
  end
end