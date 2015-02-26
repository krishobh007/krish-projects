class UpdateExistingHotelChainsWithBeaconProximityUuid < ActiveRecord::Migration
  def change
    hotel_chains = HotelChain.all
    hotel_chains.each do |hotel_chain|
      
      hotel_chain.update_attributes(:beacon_uuid_proximity => SecureRandom.uuid)
      
    end
  end
end
