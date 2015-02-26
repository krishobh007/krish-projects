class AddOriginalTransactionIdToFinancialTransactions < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :original_transaction_id, :integer
  end
end
