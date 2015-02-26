class AddRequireExternalPmsToMenu < ActiveRecord::Migration
  def change
    add_column :admin_menu_options, :require_external_pms, :boolean, default:false
  end
end
