class AllowFinancialPriceToBeNull < ActiveRecord::Migration
  def change
    change_column :financial_transactions, :amount, :float, null: true
  end
end
