class AddExtIdToReservationNotes < ActiveRecord::Migration
  def change
    add_column :reservation_notes, :external_id, :string
    add_column :reservation_notes, :is_guest_viewable, :boolean
  end
end
