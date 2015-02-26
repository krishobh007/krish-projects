class UpdateRoomsManitanceMenuHideExternalPms < ActiveRecord::Migration
  # As per CICO-9809 hiding rooms->Manintance Menu option for connected pms.
  def change
    execute('UPDATE admin_menu_options SET require_standalone_pms = 1 where id = 20 and admin_menu_id = 5')
  end
end
