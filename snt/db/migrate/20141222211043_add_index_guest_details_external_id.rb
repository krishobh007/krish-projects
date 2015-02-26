class AddIndexGuestDetailsExternalId < ActiveRecord::Migration
  def change
    add_index :guest_details, [:hotel_chain_id, :external_id]
    add_index :guest_details, [:hotel_chain_id, :last_name, :first_name], name: 'idx_guest_details_first_last'
  end
end
