class RenameCountryUserAddress < ActiveRecord::Migration
  def up
    remove_column :user_addresses, :country
    add_column :user_addresses, :country_id, :integer
  end

  def down
    remove_column :user_addresses, :country_id
    add_column :user_addresses, :country, :string
  end
end
