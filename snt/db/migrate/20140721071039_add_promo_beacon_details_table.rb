class AddPromoBeaconDetailsTable < ActiveRecord::Migration
  def change
    create_table :promo_beacon_details do |t|
      t.string :title
      t.string :description
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.timestamps
    end
  end
end
