class DropUnusedTables < ActiveRecord::Migration
  def up
    drop_table :user_memberships
    drop_table :users_features
    drop_table :user_contacts
    drop_table :user_addresses
    drop_table :user_payment_types
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
