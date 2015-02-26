class UpdateRulesRestrictionsMenuConnectedPms < ActiveRecord::Migration
  def change
    execute "UPDATE admin_menu_options SET require_standalone_pms=true WHERE action_state='admin.rulesRestrictions'"
  end
end
