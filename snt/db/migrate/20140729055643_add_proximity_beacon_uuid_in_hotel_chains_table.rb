class AddProximityBeaconUuidInHotelChainsTable < ActiveRecord::Migration
  def change
    add_column :hotel_chains, :beacon_uuid_proximity, :string 
  end
end
