class RenameGuestAdditionalContacts < ActiveRecord::Migration
  def up
    rename_table :guest_additional_contacts, :additional_contacts
  end
end
