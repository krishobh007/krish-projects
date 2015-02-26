# This migration comes from community_engine (originally 45)
class AddingIndexes < ActiveRecord::Migration
  def self.up
    add_index :comments, :recipient_id
    add_index :photos, :parent_id
    add_index :comments, :created_at
    add_index :users, :avatar_id
    add_index :comments, :commentable_type
    add_index :comments, :commentable_id    
    add_index :users, :activated_at
    add_index :users, :vendor
    add_index :users, :login_slug
  end

  def self.down
    remove_index :comments, :recipient_id
    remove_index :photos, :parent_id
    remove_index :comments, :created_at
    remove_index :users, :avatar_id
    remove_index :comments, :commentable_type
    remove_index :comments, :commentable_id
    remove_index :users, :activated_at
    remove_index :users, :vendor
    remove_index :users, :login_slug
  end
end
