class AddGroupIdToSbPosts < ActiveRecord::Migration
  def change
    add_column :sb_posts, :group_id, :integer
  end
end
