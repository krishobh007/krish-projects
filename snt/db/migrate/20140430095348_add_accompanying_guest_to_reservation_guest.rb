class AddAccompanyingGuestToReservationGuest < ActiveRecord::Migration
  def change
    add_column :reservations_guest_details, :is_accompanying_guest, :boolean, :default=>false
  end
end
