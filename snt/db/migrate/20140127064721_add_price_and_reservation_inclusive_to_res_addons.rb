class AddPriceAndReservationInclusiveToResAddons < ActiveRecord::Migration
  def change
    add_column :reservations_addons, :price, :float
    add_column :reservations_addons, :is_inclusive_in_rate, :boolean
  end
end
