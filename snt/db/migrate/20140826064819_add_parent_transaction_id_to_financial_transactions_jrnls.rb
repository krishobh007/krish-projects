class AddParentTransactionIdToFinancialTransactionsJrnls < ActiveRecord::Migration
  def change
    add_column :financial_transactions_jrnls, :parent_transaction_id, :integer
  end
end
