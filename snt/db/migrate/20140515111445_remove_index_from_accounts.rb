class RemoveIndexFromAccounts < ActiveRecord::Migration
  def up
    remove_index :accounts, :name => 'index_accounts_uniq'
  end
end
