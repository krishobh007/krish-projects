class AddHotelIdToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :hotel_id, :integer
  end
end
