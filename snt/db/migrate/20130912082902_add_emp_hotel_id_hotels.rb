class AddEmpHotelIdHotels < ActiveRecord::Migration
  def up
    add_column :users, :emp_hotel_id, :integer
  end

  def down
    remove_column :users, :emp_hotel_id, :integer
  end
end
