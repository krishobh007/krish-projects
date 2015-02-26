class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string :name
      t.integer :staffs_count
      t.integer :guests_count
      t.integer :posts_today_count
      t.integer :posts_month_count
      t.integer :number_of_rooms
      t.string :alias
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size
      t.integer :zipcode
      t.integer :hotel_phone
      t.string :short_name
      t.datetime :checkout_time
      t.integer :arr_grace_period
      t.integer :dep_grace_period
      t.integer :groups_count
      t.integer :checkin_bypass, limit: 1
      t.float :latitude, precision: 10, scale: 6
      t.float :longitude, precision: 10, scale: 6
      t.string :city
      t.string :state
      t.references :country
      t.time :checkin_time
      t.string :welcome_msg
      t.string :welcome_msg_detail
      t.string :sl_checkin_msg

      t.timestamps
    end
  end
end
