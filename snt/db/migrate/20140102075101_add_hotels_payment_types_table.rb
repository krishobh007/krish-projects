class AddHotelsPaymentTypesTable < ActiveRecord::Migration
  def up
    create_table :hotels_payment_types, id: false do |t|
      t.references :hotel
      t.references :ref_payment_type
    end
    add_index :hotels_payment_types, :hotel_id
  end

  def down
    drop_table :hotels_payment_types
  end
end
