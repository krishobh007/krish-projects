class CreateBookingOrigins < ActiveRecord::Migration
  def change
    create_table :booking_origins do |t|
      t.string :code
      t.string :description
      t.boolean :is_active
      t.integer :hotel_id
      t.timestamps
    end
  end
end
