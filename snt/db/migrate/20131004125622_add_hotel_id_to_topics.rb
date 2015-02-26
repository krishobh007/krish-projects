class AddHotelIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :hotel_id, :integer
  end
end
