class AddHotelFromAddresToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :hotel_from_address, :string
  end
end
