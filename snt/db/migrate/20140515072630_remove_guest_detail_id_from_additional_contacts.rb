class RemoveGuestDetailIdFromAdditionalContacts < ActiveRecord::Migration
  def up
    remove_column :additional_contacts, :guest_detail_id
  end
end
