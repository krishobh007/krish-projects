class DropRoomFeatures < ActiveRecord::Migration
  def up
    drop_table :room_features
  end

  def down
    create_table :room_features do |t|
      t.references :chain, index: true
      t.references :hotel, index: true
      t.string :room_feature, limit: 20, null: false
      t.string :short_desc, limit: 40, null: false
      t.string :description, limit: 2000
      t.timestamps
      t.userstamps
    end
  end
end
