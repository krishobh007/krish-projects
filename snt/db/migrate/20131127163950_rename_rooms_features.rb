class RenameRoomsFeatures < ActiveRecord::Migration
  def change
    rename_table :room_features_rooms, :rooms_features
    rename_column :rooms_features, :room_feature_id, :feature_id

    execute 'DELETE FROM rooms_features'
  end
end
