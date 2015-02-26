class RemoveChainIdFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :hotel_chain_id
  end

  def down
    add_column :accounts, :hotel_chain_id, :integer
  end
end
