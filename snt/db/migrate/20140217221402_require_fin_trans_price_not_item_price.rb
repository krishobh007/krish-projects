class RequireFinTransPriceNotItemPrice < ActiveRecord::Migration
  def change
    change_column :financial_transactions, :amount, :float, null: false
  end
end
