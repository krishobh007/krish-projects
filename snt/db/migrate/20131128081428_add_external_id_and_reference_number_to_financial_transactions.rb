class AddExternalIdAndReferenceNumberToFinancialTransactions < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :external_id, :string
    add_column :financial_transactions, :reference_number, :string
  end
end
