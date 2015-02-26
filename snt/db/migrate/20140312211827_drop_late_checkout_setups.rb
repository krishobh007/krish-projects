class DropLateCheckoutSetups < ActiveRecord::Migration
  def change
    add_column :hotels, :late_checkout_charge_code_id, :integer
    add_column :late_checkout_charges, :hotel_id, :integer

    execute 'update late_checkout_charges c, late_checkout_setups s set c.hotel_id = s.hotel_id where c.late_checkout_setup_id = s.id'
    execute 'update late_checkout_setups s, hotels h set h.late_checkout_charge_code_id = s.upsell_charge_code_id where s.hotel_id = h.id'

    change_column :late_checkout_charges, :hotel_id, :integer, null: false

    remove_index :late_checkout_charges, name: 'index_late_checkout_charges_uniq'
    add_index :late_checkout_charges, [:hotel_id, :extended_checkout_time], unique: true, name: 'index_late_checkout_charges_uniq'

    remove_column :late_checkout_charges, :late_checkout_setup_id
    drop_table :late_checkout_setups
  end
end
