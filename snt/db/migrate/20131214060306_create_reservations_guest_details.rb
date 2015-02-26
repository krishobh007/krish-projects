class CreateReservationsGuestDetails < ActiveRecord::Migration
  def change
    create_table :reservations_guest_details do |t|
      t.integer :id
      t.boolean :is_primary
      t.references :reservation
      t.references :guest_detail

      t.timestamps
    end
  end
end
