class CreateReservationPaymentTypes < ActiveRecord::Migration
  def change
    create_table :reservation_payment_types do |t|
      t.references :reservation, null: false, index: true
      t.references :user_payment_type, null: false, index: true
      t.integer :external_id

      t.references :created_by, null: false
      t.references :updated_by, null: false
      t.timestamps
    end
  end
end
