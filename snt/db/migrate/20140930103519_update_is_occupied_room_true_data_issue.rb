class UpdateIsOccupiedRoomTrueDataIssue < ActiveRecord::Migration
  def change
    execute('update rooms set is_occupied = false where rooms.room_no not in (600, 603) and hotel_id = 5')
  end
end
