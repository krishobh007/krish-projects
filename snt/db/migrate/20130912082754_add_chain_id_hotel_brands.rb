class AddChainIdHotelBrands < ActiveRecord::Migration
  def up
    add_column :hotel_brands, :hotel_chain_id, :integer
  end

  def down
    remove_column :hotel_brands, :hotel_chain_id
  end
end
