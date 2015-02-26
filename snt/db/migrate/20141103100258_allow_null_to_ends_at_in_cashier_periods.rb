class AllowNullToEndsAtInCashierPeriods < ActiveRecord::Migration
  def change
  	change_column :cashier_periods, :ends_at, :datetime, null: true
  end
end
