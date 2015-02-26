class TruncateAllAdminMenuItems < ActiveRecord::Migration
  def change
    execute('TRUNCATE admin_menus')
    execute('TRUNCATE admin_menu_options')
    execute('TRUNCATE admin_menu_option_translations')
    execute('TRUNCATE admin_menu_translations')
  end
end
