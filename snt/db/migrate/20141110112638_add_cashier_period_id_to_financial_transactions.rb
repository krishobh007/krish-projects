class AddCashierPeriodIdToFinancialTransactions < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :cashier_period_id, :integer
  end
end
