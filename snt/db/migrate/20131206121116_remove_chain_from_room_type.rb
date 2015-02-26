class RemoveChainFromRoomType < ActiveRecord::Migration
  def up
    remove_column :room_types, :chain_id
  end

  def down
    add_column :room_types, :chain_id
  end
end
