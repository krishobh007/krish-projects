class AddIsHousekeepingOnlyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_housekeeping_only, :boolean, default: false
  end
end
