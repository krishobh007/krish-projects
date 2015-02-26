class AddStreetToHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :street, :string
  end
end
