class ChangeLabelInGuestAddresses < ActiveRecord::Migration
  def change
    remove_column :guest_addresses, :label
    add_column :guest_addresses, :label_id, :integer
  end
end
