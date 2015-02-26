class CreateHotelCheckinSetups < ActiveRecord::Migration
  def change
    create_table :hotel_checkin_setups do |t|
      t.string :alert_message, limit: 500
      t.boolean :is_on
      t.boolean :is_alert_on_room_ready
      t.references :hotel
      t.references :created_by
      t.references :updated_by
      t.timestamps
    end
  end
end
