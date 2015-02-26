class ChangeAdminMenuNameForWorkStation < ActiveRecord::Migration
  def change
    interfaces_menu = AdminMenu.find_by_name_and_available_for('Interfaces', Setting.admin_menu_available_for[:hotel_admin])
    
    menu = AdminMenuOption.find_by_action_state('admin.deviceMapping')
    if menu.nil?
      AdminMenuOption.create(name: 'Workstations', action_path: '#',
                           admin_menu_id: interfaces_menu.id, icon_class: 'icon-admin-menu icon-device-mapping', action_state: 'admin.deviceMapping')
    else
      menu.name = 'Workstations'
      menu.action_path = '#'
      menu.icon_class = 'icon-admin-menu icon-device-mapping'
      menu.action_state = 'admin.deviceMapping'
      menu.save
    end
    
  end

  
end
