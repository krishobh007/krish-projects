class AddIdToReservationsAddons < ActiveRecord::Migration
  def change
    add_column :reservations_addons, :id, :primary_key
  end
end
