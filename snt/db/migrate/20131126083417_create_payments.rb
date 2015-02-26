class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :reference_number
      t.references :hotel
      t.integer :payment_type_id

      t.timestamps
    end
  end
end
