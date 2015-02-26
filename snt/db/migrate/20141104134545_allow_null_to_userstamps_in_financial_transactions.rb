class AllowNullToUserstampsInFinancialTransactions < ActiveRecord::Migration
  def change
  	change_column :financial_transactions, :creator_id, :integer, null: true
  	change_column :financial_transactions, :updater_id, :integer, null: true
  end
end
