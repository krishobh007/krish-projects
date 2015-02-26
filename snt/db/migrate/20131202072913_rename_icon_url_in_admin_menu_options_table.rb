class RenameIconUrlInAdminMenuOptionsTable < ActiveRecord::Migration
  def change
    rename_column :admin_menu_options, :icon_url, :icon_class
  end
end
