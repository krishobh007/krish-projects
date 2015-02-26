class AddTimeZoneInfoToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :tz_info, :string
  end
end
