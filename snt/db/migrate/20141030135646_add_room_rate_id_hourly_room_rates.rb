class AddRoomRateIdHourlyRoomRates < ActiveRecord::Migration
  def change
    add_column :hourly_room_rates, :room_rate_id, :integer
  end
end
