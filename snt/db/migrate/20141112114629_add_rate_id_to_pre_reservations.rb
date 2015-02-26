class AddRateIdToPreReservations < ActiveRecord::Migration
  def change
  	add_column :pre_reservations, :rate_id, :integer, :null => false
  end
end
