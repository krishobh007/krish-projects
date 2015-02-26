class AddCommentCountToSbPost < ActiveRecord::Migration
  def change
    add_column :sb_posts, :comment_count, :integer, default: 0
  end
end
