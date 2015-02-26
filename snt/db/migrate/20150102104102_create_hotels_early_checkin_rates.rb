class CreateHotelsEarlyCheckinRates < ActiveRecord::Migration
  def up
  	create_table "hotels_early_checkin_rates" do |t|
      t.integer :hotel_id
      t.integer :rate_id
    end
  end
end
