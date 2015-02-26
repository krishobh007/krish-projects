class UseReservationPaymentTypesJoinTable < ActiveRecord::Migration
  def up
    drop_table :reservation_payment_types

    create_table :reservations_guest_payment_types, id: false do |t|
      t.references :reservation, null: false, index: true
      t.references :guest_payment_type, null: false, index: true
    end
  end

  def down
    drop_table :reservations_payment_types

    create_table :reservation_payment_types do |t|
      t.references :reservation, null: false, index: true
      t.references :guest_payment_type, null: false, index: true
      t.integer :external_id

      t.references :created_by, null: false
      t.references :updated_by, null: false
      t.timestamps
    end
  end
end
