class AddTzOffsetToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :tz_offset, :decimal, precision: 4, scale: 2
  end
end
