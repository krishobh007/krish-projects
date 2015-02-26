class AddLateCheckoutOptedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :is_opted_late_checkout, :boolean , default: 0
  end
end
