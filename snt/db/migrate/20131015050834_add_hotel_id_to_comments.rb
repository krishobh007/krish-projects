class AddHotelIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :hotel_id, :integer
    add_index :comments, :hotel_id
  end
end
