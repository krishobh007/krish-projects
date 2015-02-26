class ModifyAccountNameForAccounts < ActiveRecord::Migration
  def change
    remove_column :accounts, :account_first_name
    rename_column :accounts, :account_last_name, :account_name
  end
end
