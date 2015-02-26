class RemoveChainFromRate < ActiveRecord::Migration
  def up
    remove_column :rates, :chain_id
  end

  def down
    add_column :rates, :chain_id
  end
end
