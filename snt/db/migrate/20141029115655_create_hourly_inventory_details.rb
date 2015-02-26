class CreateHourlyInventoryDetails < ActiveRecord::Migration
  def change
    create_table :hourly_inventory_details do |t|

      t.timestamps
    end
  end
end
