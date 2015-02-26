class CreateRoomFeaturesRooms < ActiveRecord::Migration
  def change
    create_table :room_features_rooms, id: false do |t|
      t.integer :room_id, null: false
      t.integer :room_feature_id, null: false

    end

    add_index(:room_features_rooms, [:room_id, :room_feature_id], name: 'idx_room_features_rooms_id_uk', unique: true)
  end
end
