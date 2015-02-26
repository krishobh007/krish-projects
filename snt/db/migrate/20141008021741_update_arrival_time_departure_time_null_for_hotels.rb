class UpdateArrivalTimeDepartureTimeNullForHotels < ActiveRecord::Migration
  def change
    # In order to avoid the mysql exception (Mysql2::Error (Invalid date: 2022-07-00 00:00:00))
    # When merging from ng-develop to develop.
    execute('UPDATE reservations set arrival_time = null, departure_time = null ')
  end  
end
