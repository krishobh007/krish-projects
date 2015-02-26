class AllowRoomRatesToBeNull < ActiveRecord::Migration
  def change
    change_column :room_rates, :single_amount, :float, null: true
    change_column :room_rates, :double_amount, :float, null: true
    change_column :room_rates, :extra_adult_amount, :float, null: true
    change_column :room_rates, :child_amount, :float, null: true
  end
end
