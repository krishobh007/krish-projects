class AddTypeAndEodToFinancialTransactions < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :transaction_type, :string
    add_column :financial_transactions, :is_eod_transaction, :boolean, default: false
  end
end
