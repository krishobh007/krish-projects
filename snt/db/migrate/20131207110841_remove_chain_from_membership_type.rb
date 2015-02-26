class RemoveChainFromMembershipType < ActiveRecord::Migration
  def up
    remove_column :membership_types, :chain_id
  end

  def down
    add_column :membership_types, :chain_id
  end
end
