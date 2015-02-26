class AddNightCheckoutCutOffTimeToRateSet < ActiveRecord::Migration
  def change
    add_column :rate_sets, :night_checkout_cut_off_time, :datetime
  end
end
