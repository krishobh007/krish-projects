class ChangeArrialDepartureTime < ActiveRecord::Migration
  def up
  	change_column :reservations, :arrival_time, :datetime, :default => Time.now
  	change_column :reservations, :departure_time, :datetime, :default => Time.now
   end
end
