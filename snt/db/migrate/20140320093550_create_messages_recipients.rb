class CreateMessagesRecipients < ActiveRecord::Migration
  def up
   create_table :messages_recipients  do |t|
      t.integer :message_id
      t.integer :recipient_id
      t.boolean :is_read
      t.boolean :is_pushed
    end
  end
end
