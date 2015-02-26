class CreateWorkStations < ActiveRecord::Migration
  def change
    create_table :work_stations do |t|
      t.string :name
      t.references :hotel
      t.string :station_identifier

      t.timestamps
    end
    add_index :work_stations, :hotel_id
  end
end
