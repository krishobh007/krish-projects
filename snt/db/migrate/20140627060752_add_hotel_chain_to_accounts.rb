class AddHotelChainToAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :hotel_id
    add_column :accounts, :hotel_chain_id, :integer
  end
end
