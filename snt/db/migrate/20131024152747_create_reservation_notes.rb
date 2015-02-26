class CreateReservationNotes < ActiveRecord::Migration
  def change
    create_table :reservation_notes do |t|
      t.references :reservation, null: false

      t.string :note_type, limit: 40, null: false
      t.string :note_desc, limit: 2000, null: false

      t.references :created_by, null: false
      t.references :updated_by, null: false
      t.timestamps
    end
  end
end
