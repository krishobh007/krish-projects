class AllowRoomCustomRateAmountsToBeNull < ActiveRecord::Migration
  def change
    change_column :room_custom_rates, :single_amount, :float, null: true
    change_column :room_custom_rates, :double_amount, :float, null: true
    change_column :room_custom_rates, :extra_adult_amount, :float, null: true
    change_column :room_custom_rates, :child_amount, :float, null: true
  end
end
