class AddNewFieldsToHourlyInventoryDetail < ActiveRecord::Migration
  def change
    change_table :hourly_inventory_details do |t|
      t.references :hotel, index: true
      t.references :rate, index: true
      t.references :room_type, index: true
      t.date :date
      t.integer :creator_id
      t.integer :updater_id
    end
    # add_column :hourly_inventory_details, :hotel, :references
    # add_column :hourly_inventory_details, :date, :date
    # add_column :hourly_inventory_details, :rate, :references
    # add_column :hourly_inventory_details, :room_type, :references
    # add_column :hourly_inventory_details, :creator_id, :integer
    # add_column :hourly_inventory_details, :updater_id, :integer
  end
end
