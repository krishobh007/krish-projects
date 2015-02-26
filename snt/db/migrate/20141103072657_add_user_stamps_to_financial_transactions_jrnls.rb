class AddUserStampsToFinancialTransactionsJrnls < ActiveRecord::Migration
  def change
    add_column :financial_transactions_jrnls, :creator_id, :integer
    add_column :financial_transactions_jrnls, :updater_id, :integer
  end
end
