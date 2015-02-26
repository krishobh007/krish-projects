class AddFavoritesToItems < ActiveRecord::Migration
  def change
    add_column :items, :is_favorite, :boolean, default: false
  end
end
