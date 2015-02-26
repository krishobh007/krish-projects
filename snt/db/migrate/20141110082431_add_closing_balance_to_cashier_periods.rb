class AddClosingBalanceToCashierPeriods < ActiveRecord::Migration
  def change
    add_column :cashier_periods, :closing_balance_cash, :float
    add_column :cashier_periods, :closing_balance_check, :float
  end
end
