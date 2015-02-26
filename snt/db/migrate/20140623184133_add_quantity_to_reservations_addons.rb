class AddQuantityToReservationsAddons < ActiveRecord::Migration
  def change
    add_column :reservations_addons, :quantity, :integer, null: false, default: 1
  end
end
