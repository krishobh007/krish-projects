class AddIsFromExternalSystemToReservationNotes < ActiveRecord::Migration
  def change
    add_column :reservation_notes, :is_from_external_system, :boolean
  end
end
