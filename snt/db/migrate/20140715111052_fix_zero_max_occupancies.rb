class FixZeroMaxOccupancies < ActiveRecord::Migration
  def change
    execute('update rooms set max_occupancy = null where max_occupancy = 0')
    execute('update room_types set max_occupancy = null where max_occupancy = 0')
  end
end
