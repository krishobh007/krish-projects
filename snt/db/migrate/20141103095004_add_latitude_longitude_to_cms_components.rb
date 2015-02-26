class AddLatitudeLongitudeToCmsComponents < ActiveRecord::Migration
  def change
    add_column :cms_components, :latitude, :float, null: false
    add_column :cms_components, :longitude, :float, null: false
  end
end
