class ChangeReservationNoteUserColumns < ActiveRecord::Migration
  def change
    change_column :reservation_notes, :created_by_id, :integer, null: true
    change_column :reservation_notes, :updated_by_id, :integer, null: true
  end
end
