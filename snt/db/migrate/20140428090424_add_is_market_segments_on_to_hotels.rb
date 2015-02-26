class AddIsMarketSegmentsOnToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :is_market_segments_on, :boolean
  end
end
