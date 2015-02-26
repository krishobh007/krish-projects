class AddColumnToHourlyRoomRates < ActiveRecord::Migration
  def change
  	add_column :hourly_room_rates, :hour, :integer
  	add_column :hourly_room_rates, :amount, :float
  end
end
