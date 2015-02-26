class AddTimestampsInInactiveroomsTable < ActiveRecord::Migration
  def change
    add_timestamps(:inactive_rooms)
  end
end
