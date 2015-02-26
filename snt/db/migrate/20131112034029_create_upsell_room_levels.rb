class CreateUpsellRoomLevels < ActiveRecord::Migration
  def change
    create_table :upsell_room_levels do |t|
      t.references :room_type
      t.integer :level
      t.timestamps
    end
  end
end
