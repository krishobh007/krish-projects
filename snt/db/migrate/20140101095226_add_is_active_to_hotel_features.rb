class AddIsActiveToHotelFeatures < ActiveRecord::Migration
  def change
    add_column :hotels_features , :is_active, :boolean
  end
end
