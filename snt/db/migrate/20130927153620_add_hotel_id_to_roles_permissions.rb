class AddHotelIdToRolesPermissions < ActiveRecord::Migration
  def change
    add_column :roles_permissions, :hotel_id, :integer
  end
end
