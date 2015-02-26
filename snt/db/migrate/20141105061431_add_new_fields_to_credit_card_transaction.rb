class AddNewFieldsToCreditCardTransaction < ActiveRecord::Migration
  def change
    add_column :credit_card_transactions, :external_print_data, :text
    add_column :credit_card_transactions, :external_failure_reason, :string
    add_column :credit_card_transactions, :emv_terminal_id, :string
    add_column :credit_card_transactions, :is_swiped, :boolean
    add_column :credit_card_transactions, :is_emv_pin_verified, :boolean
    add_column :credit_card_transactions, :is_emv_authorized, :boolean
    add_column :credit_card_transactions, :external_message, :string
    add_column :credit_card_transactions, :is_dcc, :boolean
    add_column :credit_card_transactions, :issue_number, :string
    add_column :credit_card_transactions, :merchant_id, :string
  end
end
