class UpdateIcareAdminUrl < ActiveRecord::Migration
  def change
    execute('update admin_menu_options set action_path = "/api/hotel_settings/icare.haml" where action_state = "admin.icareServices"')
  end
end
