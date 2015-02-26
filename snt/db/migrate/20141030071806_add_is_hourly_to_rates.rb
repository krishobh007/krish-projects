class AddIsHourlyToRates < ActiveRecord::Migration
  def change
    add_column :rates, :is_hourly_rate, :boolean, default: false
  end
end
