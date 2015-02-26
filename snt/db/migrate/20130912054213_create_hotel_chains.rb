class CreateHotelChains < ActiveRecord::Migration
  def change
    create_table :hotel_chains do |t|
      t.string :name
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size
      t.string :welcome_msg
      t.string :splash_file_name
      t.string :splash_content_type
      t.integer :splash_file_size
      t.datetime :splash_updated_at

      t.timestamps
    end
  end
end
