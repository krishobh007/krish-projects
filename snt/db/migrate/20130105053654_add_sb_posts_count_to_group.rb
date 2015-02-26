class AddSbPostsCountToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :sb_posts_count, :integer
  end
end
