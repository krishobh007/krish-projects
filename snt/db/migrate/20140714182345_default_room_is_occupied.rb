class DefaultRoomIsOccupied < ActiveRecord::Migration
  def change
    execute('update rooms set is_occupied = false where is_occupied is null')
    change_column :rooms, :is_occupied, :boolean, null: false, default: false
  end
end
