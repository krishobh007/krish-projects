class AddRequireStandalonePmsToAdminMenuOptions < ActiveRecord::Migration
  def change
    add_column :admin_menu_options,:require_standalone_pms,:boolean,:default=>false
  end
end
