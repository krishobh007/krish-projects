class AddMaxOccupancyRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :max_occupancy, :integer
  end
end
