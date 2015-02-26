class AddFinancialTransactionsIndex < ActiveRecord::Migration
  def change
    add_index :charge_groups, :hotel_id
    add_index :financial_transactions, [:charge_code_id, :date], name: 'idx_financial_trans_charge_code_date'
  end
end
