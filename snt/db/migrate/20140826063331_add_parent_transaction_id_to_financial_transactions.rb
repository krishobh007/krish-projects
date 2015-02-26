class AddParentTransactionIdToFinancialTransactions < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :parent_transaction_id, :integer
  end
end
