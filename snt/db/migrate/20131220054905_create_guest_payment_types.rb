class CreateGuestPaymentTypes < ActiveRecord::Migration
  def change
    create_table :guest_payment_types do |t|
      t.references :guest_detail
      t.string :card_number
      t.string :encrypted_card_number, limit: 200
      t.string :card_token
      t.string :card_expiry
      t.string :card_cvv, limit: 20
      t.string :card_name
      t.string :bank_routing_no, limit: 80
      t.string :account_no, limit: 80
      t.boolean :is_primary
      t.string :external_id, limit: 80
      t.boolean :is_on_guest_card
      t.integer :payment_type_id
      t.integer :credit_card_type_id
      t.userstamps
      t.timestamps
    end
  end
end
