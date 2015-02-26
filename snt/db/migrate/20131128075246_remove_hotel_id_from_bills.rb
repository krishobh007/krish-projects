class RemoveHotelIdFromBills < ActiveRecord::Migration
  def up
    remove_column :bills, :hotel_id
  end

  def down
    add_column :bills, :hotel_id, :integer
  end
end
