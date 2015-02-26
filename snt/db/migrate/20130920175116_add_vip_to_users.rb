class AddVipToUsers < ActiveRecord::Migration
  def up
    add_column :users, :vip, :boolean
  end

  def down
    remove_column :users, :vip
  end
end
