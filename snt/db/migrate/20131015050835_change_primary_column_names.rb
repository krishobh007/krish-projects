class ChangePrimaryColumnNames < ActiveRecord::Migration
  def change
    rename_column :user_addresses, :primary_value, :is_primary
    rename_column :user_contacts, :primary_value, :is_primary
  end
end
