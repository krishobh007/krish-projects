class AddTimeToFinancialTransactions < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :time, :time
  end
end
