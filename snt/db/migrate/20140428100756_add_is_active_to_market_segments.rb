class AddIsActiveToMarketSegments < ActiveRecord::Migration
  def change
    add_column :market_segments, :is_active, :boolean
  end
end
