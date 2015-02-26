class RestructurePromoBeaconDetailsTable < ActiveRecord::Migration
  def change
    add_column :promo_beacon_details, :is_inactive, :integer
    add_column :promo_beacon_details, :hotel_id, :integer, null: false
    add_column :promo_beacon_details, :image_id, :integer
    remove_column :promo_beacon_details, :image_file_name
    remove_column :promo_beacon_details, :image_content_type
    remove_column :promo_beacon_details, :image_file_size
    remove_column :promo_beacon_details, :image_updated_at
    rename_table :promo_beacon_details, :promotions
  end
end
