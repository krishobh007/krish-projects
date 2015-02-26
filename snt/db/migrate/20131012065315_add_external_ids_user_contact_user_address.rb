class AddExternalIdsUserContactUserAddress < ActiveRecord::Migration
  def change
    add_column :user_contacts, :external_id, :integer
    add_column :user_addresses, :external_id, :integer
  end
end
