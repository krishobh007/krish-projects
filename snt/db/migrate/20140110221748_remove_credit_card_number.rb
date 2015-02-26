class RemoveCreditCardNumber < ActiveRecord::Migration
  def up
    remove_column :guest_payment_types, :card_number
    remove_column :guest_payment_types, :encrypted_card_number
  end

  def down
    add_column :guest_payment_types, :card_number, :string
    add_column :guest_payment_types, :encrypted_card_number, :string
  end
end
