class AddLabelPrimaryToUserContacts < ActiveRecord::Migration
  def change
    add_column :user_contacts, :primary, :boolean
    add_column :user_contacts, :label, :string
  end
end
