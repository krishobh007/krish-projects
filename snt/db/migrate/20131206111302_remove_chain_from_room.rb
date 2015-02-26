class RemoveChainFromRoom < ActiveRecord::Migration
  def up
    remove_column :rooms, :chain_id
  end

  def down
    add_column :rooms, :chain_id
  end
end
