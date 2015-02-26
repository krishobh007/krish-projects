class CreateFinancialTransactions < ActiveRecord::Migration
  def change
    create_table :financial_transactions do |t|
      t.date :date
      t.float :amount, length: 10, decimals: 2
      t.string :currency_code
      t.references :payment
      t.references :charge_code
      t.references :bill
      t.timestamps
    end
  end
end
