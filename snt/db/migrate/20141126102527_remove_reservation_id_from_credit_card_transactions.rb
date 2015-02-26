class RemoveReservationIdFromCreditCardTransactions < ActiveRecord::Migration
  def up
    remove_column :credit_card_transactions, :credit_card_type_id
    remove_column :credit_card_transactions, :card_name
    remove_column :credit_card_transactions, :card_expiry
    remove_column :credit_card_transactions, :card_number_last4
    remove_column :credit_card_transactions, :reservation_id
    remove_column :credit_card_transactions, :parent_id
    remove_column :credit_card_transactions, :token
    
    rename_column :credit_card_transactions, :external_transaction_id, :external_transaction_ref
    rename_column :credit_card_transactions, :autherization_code, :authorization_code
  end

  def down
  end
end
