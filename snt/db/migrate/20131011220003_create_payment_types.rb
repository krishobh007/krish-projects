class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.references :hotel, index: true, null: false
      t.references :chain, index: true, null: false
      t.string :payment_type, limit: 40, null: false
      t.string :card_type, limit: 40
      t.string :merchant_no, limit: 80
      t.string :issue_no, limit: 80
      t.references :created_by, null: false
      t.references :updated_by, null: false

      t.timestamps
    end
  end
end
