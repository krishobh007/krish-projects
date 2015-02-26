class CreateLateCheckoutCharges < ActiveRecord::Migration
  def change
    create_table :late_checkout_charges do |t|
      t.time :extended_checkout_time
      t.float :extended_checkout_charge
      t.references :hotel
      t.timestamps
    end
  end
end
