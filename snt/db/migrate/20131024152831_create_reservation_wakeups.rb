class CreateReservationWakeups < ActiveRecord::Migration
  def change
    create_table :wakeups do |t|
      t.references :reservation, null: false
      t.references :hotel, null: false
      t.string :room_no

      t.date :start_date, null: false
      t.date :end_date, null: false

      t.time :time, null: false

      t.string :status, limit: 20

      t.references :created_by, null: false
      t.references :updated_by, null: false
      t.timestamps
    end
  end
end
