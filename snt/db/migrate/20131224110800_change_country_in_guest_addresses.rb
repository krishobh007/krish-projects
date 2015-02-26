class ChangeCountryInGuestAddresses < ActiveRecord::Migration
  def change
    remove_column :guest_addresses, :country
    add_column :guest_addresses, :country_id, :integer
  end
end
