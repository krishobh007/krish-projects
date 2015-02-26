class RemoveIsOutOfOrderRooms < ActiveRecord::Migration
  def change
    remove_column :rooms, :is_out_of_order
  end
end
