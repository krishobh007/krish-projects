class AddIndexToReservations < ActiveRecord::Migration
  def change
    add_index :reservations, :dep_date
    add_index :reservations, :status
  end
end
