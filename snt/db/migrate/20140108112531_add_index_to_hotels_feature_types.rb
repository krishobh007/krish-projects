class AddIndexToHotelsFeatureTypes < ActiveRecord::Migration
  def change
    add_index :hotels_feature_types, [:hotel_id, :feature_type_id], unique: true
  end
end
