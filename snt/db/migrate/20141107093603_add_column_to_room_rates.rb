class AddColumnToRoomRates < ActiveRecord::Migration
  def change
    add_column :room_rates, :day_hourly_incr_amount, :float
    add_column :room_rates, :night_hourly_incr_amount, :float
  end
end
