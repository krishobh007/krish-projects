class AddIsActiveToHotelsMemberships < ActiveRecord::Migration
  def change
    add_column :hotels_memberships, :is_active, :boolean,  default: true
  end
end
