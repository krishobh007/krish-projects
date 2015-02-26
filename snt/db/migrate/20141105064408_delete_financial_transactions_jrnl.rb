class DeleteFinancialTransactionsJrnl < ActiveRecord::Migration
  def change
  	drop_table :financial_transactions_jrnls
  end
end
