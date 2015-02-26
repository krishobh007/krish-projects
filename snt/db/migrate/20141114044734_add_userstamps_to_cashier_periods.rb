class AddUserstampsToCashierPeriods < ActiveRecord::Migration
  def change
    add_column :cashier_periods, :creator_id, :integer, null: true
    add_column :cashier_periods, :updater_id, :integer, null: true
  end
end
