class CreateMarketSegments < ActiveRecord::Migration
  create_table :market_segments do |t|
  	t.string :name
  	t.references :hotel
  	t.timestamps
  end
end
