class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|

      t.references :hotel
      t.references :reservation
      t.references :account
      t.integer :bill_number

      t.timestamps
    end
  end
end
