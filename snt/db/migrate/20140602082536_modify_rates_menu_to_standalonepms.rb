class ModifyRatesMenuToStandalonepms < ActiveRecord::Migration
  def up
    execute "UPDATE admin_menu_options SET require_standalone_pms=true WHERE action_state='admin.ratesAddons'"
  end

end
