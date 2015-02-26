class AddRoomIndexToReservationDailyInstances < ActiveRecord::Migration
  def change
    add_index :reservation_daily_instances, :room_id
  end
end
