class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :creator_id
      t.integer :updater_id
      t.boolean :is_group_conversation, default: false
      t.timestamps
    end
  end
end
