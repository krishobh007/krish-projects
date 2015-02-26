class RemoveHotelTzOffset < ActiveRecord::Migration
  def change
    remove_column :hotels, :tz_offset
  end
end
