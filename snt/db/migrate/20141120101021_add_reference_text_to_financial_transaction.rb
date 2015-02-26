class AddReferenceTextToFinancialTransaction < ActiveRecord::Migration
  def change
    add_column :financial_transactions, :reference_text, :string
  end
end
