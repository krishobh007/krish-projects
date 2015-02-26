class AddUserStampsToFinancialTransactions < ActiveRecord::Migration
  def change
  	add_column :financial_transactions, :creator_id, :integer, null: false
    add_column :financial_transactions, :updater_id, :integer, null: false
  end
end
