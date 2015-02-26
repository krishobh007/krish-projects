class AddIsActiveToFinancialTransactions < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :is_active, :boolean, default: true
  end
end
