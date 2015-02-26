class AddRoomStatusToReservation < ActiveRecord::Migration
  def up
    add_column :reservations, :room_status, :string
  end

  def down
    remove_column :reservations, :room_status
  end
end
