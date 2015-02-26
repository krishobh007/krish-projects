class RenameWorkStation < ActiveRecord::Migration
  def up
    rename_table :work_stations, :workstations
    remove_column :workstations, :location_id
    rename_column :credit_card_transactions, :work_station_id, :workstation_id
  end

  def down
    rename_table :workstations, :work_stations
  end
end
