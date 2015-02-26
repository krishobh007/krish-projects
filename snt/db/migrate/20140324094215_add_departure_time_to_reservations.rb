class AddDepartureTimeToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :departure_time, :time
  end
end
