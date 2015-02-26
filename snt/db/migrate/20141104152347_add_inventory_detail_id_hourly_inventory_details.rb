class AddInventoryDetailIdHourlyInventoryDetails < ActiveRecord::Migration
  def change
    add_column :hourly_inventory_details, :inventory_detail_id, :integer
  end
end
