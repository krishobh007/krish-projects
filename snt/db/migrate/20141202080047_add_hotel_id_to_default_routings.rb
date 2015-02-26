class AddHotelIdToDefaultRoutings < ActiveRecord::Migration
  def change
  	add_column :default_account_routings, :hotel_id, :integer 
  end
end
