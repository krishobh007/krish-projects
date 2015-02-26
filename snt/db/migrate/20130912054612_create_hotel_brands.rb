class CreateHotelBrands < ActiveRecord::Migration
  def change
    create_table :hotel_brands do |t|
      t.string :name
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size

      t.timestamps
    end
  end
end
