class AddAccountNumberToAccounts < ActiveRecord::Migration
  def change
    rename_column :accounts, :corporate_id, :account_number
  end
end
