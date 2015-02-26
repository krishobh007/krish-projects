class AddCreditCardTransactionIdToFinancialTransation < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :credit_card_transaction_id, :integer
  end
end
