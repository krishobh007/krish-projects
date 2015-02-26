class AddCardNameAndCardExpiryToCreditCardTransaction < ActiveRecord::Migration
  def change
    add_column :credit_card_transactions, :card_name, :string
    add_column :credit_card_transactions, :card_expiry, :string
    add_column :credit_card_transactions, :card_number_last4, :string
  end
end
