class AddInfantsToDailyInstances < ActiveRecord::Migration
  def change
    add_column :reservation_daily_instances, :infants, :integer
  end
end
