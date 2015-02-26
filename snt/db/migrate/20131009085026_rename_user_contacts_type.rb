class RenameUserContactsType < ActiveRecord::Migration
  def change
    rename_column :user_contacts, :type, :contact_type
  end
end
