class AddAddonIsActive < ActiveRecord::Migration
  def change
    add_column :addons, :is_active, :boolean, null: false, default: true
  end
end
