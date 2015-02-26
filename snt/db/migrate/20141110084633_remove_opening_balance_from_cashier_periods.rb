class RemoveOpeningBalanceFromCashierPeriods < ActiveRecord::Migration
  def change
  	remove_column :cashier_periods, :opening_balance_cash
  	remove_column :cashier_periods, :opening_balance_check
  end
end
