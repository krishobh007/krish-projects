class AssociateExistingReservationNotes < ActiveRecord::Migration
  def change
    execute("UPDATE notes SET associated_type='Reservation' WHERE associated_type IS NULL")
  end
end
