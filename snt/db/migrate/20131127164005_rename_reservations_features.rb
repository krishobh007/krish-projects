class RenameReservationsFeatures < ActiveRecord::Migration
  def change
    rename_table :reservations_preferences, :reservations_features
    rename_column :reservations_features, :preference_id, :feature_id

    execute 'DELETE FROM reservations_features'
  end
end
