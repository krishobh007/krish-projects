class AddNeighbourhoodTableForBeaconSelfReference < ActiveRecord::Migration
  def change
    create_table(:neighbourhoods, :id => false) do |t|
      t.integer :beacon_id, null: false
      t.integer :neighbour_id, null: false
    end
  end
end
