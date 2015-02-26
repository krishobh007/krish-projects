class CreateRefHotelMessageKeys < ActiveRecord::Migration
  def change
    create_table :ref_hotel_message_keys do |t|
      t.string :value, null: false
      t.string :description
      t.timestamps
    end
  end
end
