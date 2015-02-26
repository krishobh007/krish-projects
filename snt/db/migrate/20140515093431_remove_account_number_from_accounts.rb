class RemoveAccountNumberFromAccounts < ActiveRecord::Migration
  def up
    remove_column :accounts, :account_number
  end
end
