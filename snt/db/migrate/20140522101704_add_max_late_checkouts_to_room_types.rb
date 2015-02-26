class AddMaxLateCheckoutsToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :max_late_checkouts, :integer
  end
end
