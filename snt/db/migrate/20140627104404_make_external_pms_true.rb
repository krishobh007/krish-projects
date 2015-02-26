class MakeExternalPmsTrue < ActiveRecord::Migration
  def change
    execute "update admin_menu_options set require_external_pms = 1 where action_state = 'admin.externalPmsConnectivity';"
  end

end
