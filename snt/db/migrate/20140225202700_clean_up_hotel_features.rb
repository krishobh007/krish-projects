class CleanUpHotelFeatures < ActiveRecord::Migration
  def change
    execute 'delete hf from hotels_features hf, features f where hf.feature_id = f.id and f.hotel_id is not null and f.hotel_id != hf.hotel_id'
  end
end
