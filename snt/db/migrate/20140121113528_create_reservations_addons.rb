class CreateReservationsAddons < ActiveRecord::Migration
  def change
    create_table :reservations_addons, id: false do |t|
      t.references :reservation, null: false, index: true
      t.references :addon, null: false, index: true
    end
  end
end
