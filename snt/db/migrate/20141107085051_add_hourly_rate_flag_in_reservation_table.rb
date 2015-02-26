class AddHourlyRateFlagInReservationTable < ActiveRecord::Migration
  def change
    add_column :reservations, :is_hourly, :boolean, default: false
  end
end
