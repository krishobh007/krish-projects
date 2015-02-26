class FixNameOfReservationNoteDesc < ActiveRecord::Migration
  def change
    rename_column :reservation_notes, :note_desc, :description
  end
end
