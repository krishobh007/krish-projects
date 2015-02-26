class ChangeLabelInGuestAdditionalContacts < ActiveRecord::Migration
  def change
    remove_column :guest_additional_contacts, :label
    add_column :guest_additional_contacts, :label_id, :integer
  end
end
