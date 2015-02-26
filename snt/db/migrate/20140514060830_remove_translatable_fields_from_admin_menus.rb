class RemoveTranslatableFieldsFromAdminMenus < ActiveRecord::Migration
  def change
    remove_column :admin_menus, :description
    remove_column :admin_menus, :name
  end
end
