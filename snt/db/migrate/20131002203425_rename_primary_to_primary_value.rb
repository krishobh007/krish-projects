class RenamePrimaryToPrimaryValue < ActiveRecord::Migration
  def change
    rename_column :user_contacts, :primary, :primary_value
    rename_column :user_addresses, :primary, :primary_value
  end
end
