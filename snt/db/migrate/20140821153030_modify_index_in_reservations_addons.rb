class ModifyIndexInReservationsAddons < ActiveRecord::Migration
  def change
    change_column_null :reservations_addons, :price, true
  end
end
