class RemoveDefaultFromReservationArrivalDepTime < ActiveRecord::Migration
  def change
  	change_column :reservations, :arrival_time, :datetime, :default => nil
  	change_column :reservations, :departure_time, :datetime, :default => nil
  end
end
