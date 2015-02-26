class AddCommentsToFinancialTransactions < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :comments, :text
  end
end
