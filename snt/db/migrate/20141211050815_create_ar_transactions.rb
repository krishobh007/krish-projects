class CreateArTransactions < ActiveRecord::Migration
  def change
    create_table :ar_transactions do |t|
      t.integer :hotel_id
      t.integer :bill_id
      t.integer :account_id
      t.integer :reservation_id
      t.float :credit
      t.float :debit
      t.date :paid_on
      t.date :date
      t.timestamps
    end
  end
end
