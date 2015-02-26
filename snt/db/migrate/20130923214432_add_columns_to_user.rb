class AddColumnsToUser < ActiveRecord::Migration
  def up
    add_column :users, :image_url, :string
    add_column :users, :city, :string
  end

  def down
    remove_column :users, :image_url
    remove_column :users, :city
  end
end
