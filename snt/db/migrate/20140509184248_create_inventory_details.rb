class CreateInventoryDetails < ActiveRecord::Migration
  def change
    create_table :inventory_details do |t|
      t.references :hotel, null: false
      t.date :date, null: false
      t.references :rate, null: false
      t.references :room_type, null: false
      t.integer :sold, null: false
      t.timestamps
      t.userstamps
    end
  end
end
