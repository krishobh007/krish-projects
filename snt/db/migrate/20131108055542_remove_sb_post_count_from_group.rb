class RemoveSbPostCountFromGroup < ActiveRecord::Migration
  def up
    remove_column :groups, :sb_posts_count
  end

  def down
    add_column :groups, :sb_posts_count, :integer
  end
end
