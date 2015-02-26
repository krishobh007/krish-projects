class CreateHotelMessagesAndTranslations < ActiveRecord::Migration
  def up
    create_table :hotel_messages do |t|
      t.references :hotel
      t.string :module, null: false
      t.integer :hotel_message_key_id, null: false
      t.timestamps
    end
    HotelMessage.create_translation_table! :message => :text
  end
  def down
    drop_table :hotel_messages
    HotelMessage.drop_translation_table!
  end
end
