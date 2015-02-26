class RemoveTimestampsFromReservationsGuestDetails < ActiveRecord::Migration
  def up
    remove_column :reservations_guest_details, :created_at
    remove_column :reservations_guest_details, :updated_at
  end

  def down
    add_column :reservations_guest_details, :updated_at, :datetime
    add_column :reservations_guest_details, :created_at, :datetime
  end
end
