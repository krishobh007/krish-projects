class RemoveFloorRooms < ActiveRecord::Migration
  def up
    remove_column :rooms, :floor
  end

  def down
    add_column :rooms, :floor, :integer
  end
end
