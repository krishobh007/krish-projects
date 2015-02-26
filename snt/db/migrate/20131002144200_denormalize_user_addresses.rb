class DenormalizeUserAddresses < ActiveRecord::Migration
  def change
    remove_column :user_addresses, :state_id
    remove_column :user_addresses, :country_id

    add_column :user_addresses, :state, :string
    add_column :user_addresses, :country, :string
    add_column :user_addresses, :primary, :boolean

    rename_column :user_addresses, :type, :label
  end
end
