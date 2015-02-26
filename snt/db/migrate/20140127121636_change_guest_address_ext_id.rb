class ChangeGuestAddressExtId < ActiveRecord::Migration
  def change
    change_column :guest_addresses, :external_id, :string, null: true
  end
end
