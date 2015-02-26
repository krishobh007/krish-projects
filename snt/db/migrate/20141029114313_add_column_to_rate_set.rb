class AddColumnToRateSet < ActiveRecord::Migration
  def change
  	add_column :rate_sets, :day_min_hours, :integer
  	add_column :rate_sets, :day_max_hours, :integer
  	add_column :rate_sets, :day_hourly_incr_amount, :float
  	add_column :rate_sets, :day_checkout_cut_off_time, :datetime
  	add_column :rate_sets, :night_start_time, :datetime
  	add_column :rate_sets, :night_end_time, :datetime
  	add_column :rate_sets, :night_hourly_incr_amount, :float
  end
end
