class RemoveGuestIdFromReservations < ActiveRecord::Migration
  def up
    remove_column :reservations, :guest_id
  end

  def down
    add_column :reservations, :guest_id, :string
  end
end
