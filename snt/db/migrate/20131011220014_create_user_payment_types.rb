class CreateUserPaymentTypes < ActiveRecord::Migration
  def change
    create_table :user_payment_types do |t|
      t.references :user, index: true, null: false
      t.string :payment_type, limit: 40, null: false
      t.string :card_type, limit: 20
      t.string :card_number
      t.string :encrypted_card_num, limit: 200
      t.string :card_token, limit: 200
      t.date :card_expiry
      t.string :card_cvv, limit: 20
      t.string :card_display, limit: 20
      t.string :bank_routing_no, limit: 80
      t.string :account_no, limit: 80
      t.boolean :is_primary
      t.string :external_id, limit: 80
      t.references :created_by_id, null: false
      t.references :updated_by_id, null: false

      t.timestamps
    end
  end
end
