class AddTimezoneIndexes < ActiveRecord::Migration
  def change
    add_index :hotels, :tz_info
    add_index :hotels, :last_reservation_update
    add_index :hotel_business_dates, :status
  end
end
