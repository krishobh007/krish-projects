class CreateRatesRoomTypes < ActiveRecord::Migration
  def change
    create_table :rates_room_types do |t|
      t.references :rate, null: false
      t.references :room_type, null: false
    end
  end
end
