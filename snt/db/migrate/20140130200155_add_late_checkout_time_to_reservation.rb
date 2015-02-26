class AddLateCheckoutTimeToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :late_checkout_time, :time
  end
end
