class CreateHourlyRoomRates < ActiveRecord::Migration
  def change
    create_table :hourly_room_rates do |t|

      t.timestamps
    end
  end
end
