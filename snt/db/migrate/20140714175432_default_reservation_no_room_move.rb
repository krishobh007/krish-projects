class DefaultReservationNoRoomMove < ActiveRecord::Migration
  def change
    execute('update reservations set no_room_move = false where no_room_move is null')
    change_column :reservations, :no_room_move, :boolean, null: false, default: false
  end
end
