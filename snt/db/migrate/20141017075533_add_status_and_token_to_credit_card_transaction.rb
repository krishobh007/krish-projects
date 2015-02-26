class AddStatusAndTokenToCreditCardTransaction < ActiveRecord::Migration
  def change
    add_column :credit_card_transactions, :status, :boolean
    add_column :credit_card_transactions, :token, :string
  end
end
