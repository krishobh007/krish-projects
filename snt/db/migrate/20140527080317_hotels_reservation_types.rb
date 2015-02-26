class HotelsReservationTypes < ActiveRecord::Migration
  def up
    create_table :hotels_reservation_types do |t|
      t.references :hotel, index: true, null: false
      t.references :ref_reservation_type, index: true, null: false
    end
  end
end
