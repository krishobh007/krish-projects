class AddIndexOnInactiveRooms < ActiveRecord::Migration
  def change
    add_index :inactive_rooms, :room_id
  end
end
