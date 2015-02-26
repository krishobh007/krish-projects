class AddBeaconTable < ActiveRecord::Migration
  def change
    create_table :beacon_details do |t|
      t.string :location
      t.string :beacon_uuid
      t.string :beacon_type
      t.boolean :beacon_status, null: false, default: false
      t.string :trigger_range
      t.text :guest_message
      t.integer :hotel_id, null: false
      t.integer :promo_detail_id, null: false
      t.timestamps
    end
  end
end
