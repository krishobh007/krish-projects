class RemoveIndexForAddonsNameAndHotelId < ActiveRecord::Migration
  def change
    remove_index :addons, [:name, :hotel_id]
  end
end
