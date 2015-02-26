class AddIsInclusiveInRateAddons < ActiveRecord::Migration
  def change
    add_column :rates_addons, :is_inclusive_in_rate, :boolean, null: false, default:  true
    add_column :rates_addons, :id, :primary_key
  end
end
