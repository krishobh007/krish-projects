class AddHotelIdToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :hotel_id, :integer
  end
end
