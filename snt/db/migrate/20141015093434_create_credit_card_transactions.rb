class CreateCreditCardTransactions < ActiveRecord::Migration
  def change
    create_table :credit_card_transactions do |t|
      t.references :payment_method
      t.integer :credit_card_payment_method_id
      t.float :amount
      t.integer :req_reference_no
      t.string :transaction_id
      t.string :autherization_code
      t.integer :parent_id
      t.integer :currency_code_id
      t.integer :work_station_id

      t.timestamps
    end
    add_index :credit_card_transactions, :payment_method_id
  end
end
