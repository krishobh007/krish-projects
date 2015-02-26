class AddAdditionalContactsIndex < ActiveRecord::Migration
  def change
    add_index :additional_contacts, [:associated_address_id, :associated_address_type], name: 'idx_additional_contacts_association'
  end
end
