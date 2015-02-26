class ChangeLatitudeLongitudeNotNullInCmsComponents < ActiveRecord::Migration
  def change
    change_column :cms_components, :latitude, :float, null: true
    change_column :cms_components, :longitude, :float, null: true
  end
end
