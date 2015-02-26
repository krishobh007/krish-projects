class AddIsPrimaryToGuestAdditionalContacts < ActiveRecord::Migration
  def change
    add_column :guest_additional_contacts, :is_primary, :boolean
  end
end
