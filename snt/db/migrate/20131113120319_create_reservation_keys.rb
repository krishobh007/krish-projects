class CreateReservationKeys < ActiveRecord::Migration
  def change
    create_table :reservation_keys do |t|
      t.integer :number_of_keys
      t.integer :room_number
      t.references :reservation
      t.binary :qr_data
      t.timestamps
    end
  end
end
