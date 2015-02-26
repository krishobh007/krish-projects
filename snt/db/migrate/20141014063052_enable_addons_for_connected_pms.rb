class EnableAddonsForConnectedPms < ActiveRecord::Migration
  def change
  	execute("Update admin_menu_options set require_standalone_pms=false where action_path='/api/admin/addons'")
  end
end
