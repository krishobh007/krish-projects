class RemoveRoomFromReservationDailyInstances < ActiveRecord::Migration
  def up
    remove_column :reservation_daily_instances, :room
    add_column :reservation_daily_instances, :room_id, :integer
  end

  def down
    add_column :reservation_daily_instances, :room, :string
  end
end
