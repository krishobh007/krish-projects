class RemoveAddonMenuItem < ActiveRecord::Migration
  def up
    execute "update admin_menu_option_translations set name = 'Add-Ons' where name = 'Addons'" 
  end
end
