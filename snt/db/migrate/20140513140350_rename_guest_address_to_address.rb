class RenameGuestAddressToAddress < ActiveRecord::Migration
  def change
    rename_table :guest_addresses, :addresses
  end

end
