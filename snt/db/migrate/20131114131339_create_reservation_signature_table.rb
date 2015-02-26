class CreateReservationSignatureTable < ActiveRecord::Migration
  def change
    create_table :reservation_signatures do |t|
      t.references :reservation, null: false
      t.column :data, :binary, limit: 10.megabyte, null: false
    end
  end
end
