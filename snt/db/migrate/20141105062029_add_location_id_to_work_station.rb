class AddLocationIdToWorkStation < ActiveRecord::Migration
  def change
    add_column :work_stations, :location_id, :string
  end
end
