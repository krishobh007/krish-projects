class ChangeGuestAddresses < ActiveRecord::Migration
  def change
    remove_column :guest_additional_contacts, :contact_type
    add_column :guest_additional_contacts, :contact_type_id, :integer
  end
end
