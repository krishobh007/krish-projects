class ChangeRoomNumberOfReservationKeys < ActiveRecord::Migration
  def change
    change_column :reservation_keys, :room_number, :string
  end
end
