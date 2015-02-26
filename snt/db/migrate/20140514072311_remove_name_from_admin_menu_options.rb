class RemoveNameFromAdminMenuOptions < ActiveRecord::Migration
  def change
    remove_index 'admin_menu_options', %w(name admin_menu_id)
    remove_column :admin_menu_options, :name
  end
end
