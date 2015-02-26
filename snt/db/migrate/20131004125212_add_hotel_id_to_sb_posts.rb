class AddHotelIdToSbPosts < ActiveRecord::Migration
  def change
    add_column :sb_posts, :hotel_id, :integer
  end
end
