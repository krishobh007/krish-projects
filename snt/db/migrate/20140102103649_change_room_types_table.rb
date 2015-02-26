class ChangeRoomTypesTable < ActiveRecord::Migration
  def change
    add_column :room_types, :max_occupancy, :integer
    change_column :room_types, :no_of_rooms, :integer, null: true
  end
end
