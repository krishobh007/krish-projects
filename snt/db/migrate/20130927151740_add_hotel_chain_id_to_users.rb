class AddHotelChainIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hotel_chain_id, :integer
    add_index :users, :hotel_chain_id
 end
end
