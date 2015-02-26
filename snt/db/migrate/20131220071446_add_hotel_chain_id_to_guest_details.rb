class AddHotelChainIdToGuestDetails < ActiveRecord::Migration
  def change
    add_column :guest_details, :hotel_chain_id, :integer
  end
end
