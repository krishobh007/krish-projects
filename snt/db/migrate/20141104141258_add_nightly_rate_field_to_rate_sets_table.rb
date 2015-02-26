class AddNightlyRateFieldToRateSetsTable < ActiveRecord::Migration
  def change
    add_column :room_rates, :nightly_rate, :float
  end
end
