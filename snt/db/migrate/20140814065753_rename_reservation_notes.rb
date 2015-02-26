class RenameReservationNotes < ActiveRecord::Migration
  def change
  	 rename_table :reservation_notes, :notes
  end

end
