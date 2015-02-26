class AddChainIdBrandIdHotels < ActiveRecord::Migration
  def up
    add_column :hotels, :hotel_chain_id, :integer
    add_column :hotels, :hotel_brand_id, :integer
  end

  def down
    remove_column :hotels, :hotel_chain_id
    remove_column :hotels, :hotel_brand_id
  end
end
