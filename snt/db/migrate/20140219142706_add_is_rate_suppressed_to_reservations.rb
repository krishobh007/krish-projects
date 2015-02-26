class AddIsRateSuppressedToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :is_rate_suppressed, :boolean
  end
end
