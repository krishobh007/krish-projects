class RemoveColumnFromRateSet < ActiveRecord::Migration
  def up
    remove_column :rate_sets, :day_hourly_incr_amount
    remove_column :rate_sets, :night_hourly_incr_amount
  end

  def down
    add_column :rate_sets, :night_hourly_incr_amount, :float
    add_column :rate_sets, :day_hourly_incr_amount, :float
  end
end
