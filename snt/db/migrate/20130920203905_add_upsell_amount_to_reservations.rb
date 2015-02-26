class AddUpsellAmountToReservations < ActiveRecord::Migration
  def up
    add_column :reservations, :upsell_amount, :decimal, precision: 10, scale: 2
  end

  def down
    remove_column :reservations, :upsell_amount
  end
end
