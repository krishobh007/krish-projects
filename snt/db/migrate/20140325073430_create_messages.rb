class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :message
      t.integer :conversation_id
      t.integer :sender_id
      t.integer :creator_id
      t.integer :updater_id
      t.timestamps
    end
  end
end
