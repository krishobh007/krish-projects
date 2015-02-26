class UpdateGuestExternalIdIndexToNotUnique < ActiveRecord::Migration
  def change
    remove_index :guest_details, [:hotel_chain_id, :external_id]
    add_index :guest_details, [:hotel_chain_id, :external_id]
  end
end
