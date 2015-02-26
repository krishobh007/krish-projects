class RemoveHotelFromUrlMapping < ActiveRecord::Migration
  def up
    remove_column :url_mappings, :hotel_id
  end

  def down
    add_column :url_mappings, :hotel_id
  end
end
