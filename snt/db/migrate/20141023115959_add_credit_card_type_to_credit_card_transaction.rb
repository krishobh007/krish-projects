class AddCreditCardTypeToCreditCardTransaction < ActiveRecord::Migration
  def change
    add_column :credit_card_transactions, :credit_card_type_id, :integer
  end
end
