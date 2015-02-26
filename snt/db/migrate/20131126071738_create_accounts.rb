class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :account_type
      t.string :account_name
      t.string :account_number
      t.references :hotel
      t.references :hotel_chain
      t.timestamps
    end
  end
end
