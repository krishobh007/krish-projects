class AddIsInactiveHotelHotelChainHotelBrand < ActiveRecord::Migration
  def up
    add_column :hotels, :is_inactive, :boolean, default: false
    add_column :hotel_chains, :is_inactive, :boolean, default: false
    add_column :hotel_brands, :is_inactive, :boolean, default: false
  end

  def down
    remove_column :hotels, :is_inactive
    remove_column :hotel_chains, :is_inactive
    remove_column :hotel_brands, :is_inactive
  end
end
