class CreateOccupancyTargets < ActiveRecord::Migration
  def change
    create_table :occupancy_targets do |t|
      t.references :hotel, null: false
      t.date :date, null: false
      t.integer :target, null: false
      t.timestamps
      t.userstamps
    end
  end
end
