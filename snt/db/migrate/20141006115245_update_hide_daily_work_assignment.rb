class UpdateHideDailyWorkAssignment < ActiveRecord::Migration
  def change
    execute('UPDATE admin_menu_options SET require_standalone_pms = 1 where id = 46 and admin_menu_id = 5')
  end
end
