class SetDefaultRateIsActive < ActiveRecord::Migration
  def change
    change_column :rates, :is_active, :boolean, default: true
  end
end
