class CreateMaintenanceReasons < ActiveRecord::Migration
  def change
    create_table :maintenance_reasons do |t|
      t.integer :hotel_id
      t.string :maintenance_reason
      t.timestamps
    end
  end
end
