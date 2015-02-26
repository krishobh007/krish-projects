class AddAddressIndex < ActiveRecord::Migration
  def change
    add_index :addresses, [:associated_address_id, :associated_address_type], name: 'idx_addresses_association'
  end
end
