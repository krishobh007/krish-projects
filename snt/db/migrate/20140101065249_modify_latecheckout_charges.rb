class ModifyLatecheckoutCharges < ActiveRecord::Migration
  def change
    remove_column :late_checkout_charges, :hotel_id
    add_column :late_checkout_charges, :late_checkout_setup_id, :integer, references: :late_checkout_setups
  end
end
