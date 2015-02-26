class RemovePaymentIdFromFinancialTransactions < ActiveRecord::Migration
  def up
    remove_column :financial_transactions, :payment_id
  end

  def down
    add_column :financial_transactions, :payment_id, :integer
  end
end
