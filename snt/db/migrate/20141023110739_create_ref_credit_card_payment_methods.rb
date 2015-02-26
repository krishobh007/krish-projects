class CreateRefCreditCardPaymentMethods < ActiveRecord::Migration
  def change
    create_table :ref_credit_card_payment_methods do |t|
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
