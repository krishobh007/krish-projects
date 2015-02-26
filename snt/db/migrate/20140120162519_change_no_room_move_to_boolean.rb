class ChangeNoRoomMoveToBoolean < ActiveRecord::Migration
  def up
    execute 'UPDATE reservations SET no_room_move = null'
    change_column :reservations, :no_room_move, :boolean
    execute 'UPDATE reservations SET no_room_move = false'
  end

  def down
    execute 'UPDATE reservations SET no_room_move = null'
    change_column :reservations, :no_room_move, :string
    execute "UPDATE reservations SET no_room_move = 'N'"
  end
end
