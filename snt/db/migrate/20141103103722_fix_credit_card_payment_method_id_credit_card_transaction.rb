class FixCreditCardPaymentMethodIdCreditCardTransaction < ActiveRecord::Migration
  def up
    rename_column :credit_card_transactions, :credit_card_payment_method_id, :credit_card_transaction_type_id
    
    add_column :credit_card_transactions, :creator_id, :integer
    add_column :credit_card_transactions, :updater_id, :integer
    add_column :credit_card_transactions, :reservation_id, :integer
    add_column :credit_card_transactions, :hotel_id, :integer
    
    rename_column :credit_card_transactions, :transaction_id, :external_transaction_id
    
    rename_table :ref_credit_card_payment_methods, :ref_credit_card_transaction_types
  end

  def down
    rename_column :credit_card_transactions,  :credit_card_transaction_type_id, :credit_card_payment_method_id
    remove_column :credit_card_transactions, :creator_id
    remove_column :credit_card_transactions, :updater_id
    remove_column :credit_card_transactions, :reservation_id
    remove_column :credit_card_transactions, :hotel_id
    
    rename_column :credit_card_transactions, :external_transaction_id, :transaction_id
    
    rename_table :ref_credit_card_transaction_types, :ref_credit_card_payment_methods
  end
end
