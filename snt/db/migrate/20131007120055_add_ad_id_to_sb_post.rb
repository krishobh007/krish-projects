class AddAdIdToSbPost < ActiveRecord::Migration
  def change
    add_column :sb_posts, :ad_id, :integer
    add_index :sb_posts, :ad_id
  end
end
