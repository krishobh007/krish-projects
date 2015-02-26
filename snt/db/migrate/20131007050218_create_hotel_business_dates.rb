class CreateHotelBusinessDates < ActiveRecord::Migration
  def change
    create_table :hotel_business_dates do |t|
      t.integer :hotel_id
      t.date :business_date
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
