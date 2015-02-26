class AddDefaultToReservationsGuestDetail < ActiveRecord::Migration
  def change
    change_column :reservations_guest_details, :is_primary, :boolean , default: false
  end
end
