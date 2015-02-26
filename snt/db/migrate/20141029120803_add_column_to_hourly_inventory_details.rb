class AddColumnToHourlyInventoryDetails < ActiveRecord::Migration
  def change
  	add_column :hourly_inventory_details, :hour, :integer
  	add_column :hourly_inventory_details, :sold, :integer
  end
end
