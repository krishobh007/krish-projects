# This migration comes from community_engine (originally 60)
class StillMoreIndexes < ActiveRecord::Migration
  def self.up
    add_index :photos, :created_at
    add_index :users, :created_at
  end

  def self.down
    remove_index :photos, :created_at    
    remove_index :users, :created_at
  end
end
