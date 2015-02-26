class AddRefReservationHkStatusTable < ActiveRecord::Migration
  def change
    create_table :ref_reservation_hk_statuses do |t|
      t.string :value
      t.string :description
      t.timestamps
    end
  end
end
