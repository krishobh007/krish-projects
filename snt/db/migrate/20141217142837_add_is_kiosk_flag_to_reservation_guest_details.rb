class AddIsKioskFlagToReservationGuestDetails < ActiveRecord::Migration
  def change
    add_column :reservations_guest_details, :is_added_from_kiosk, :boolean, default: 0
  end
end
