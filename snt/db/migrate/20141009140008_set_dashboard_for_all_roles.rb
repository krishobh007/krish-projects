class SetDashboardForAllRoles < ActiveRecord::Migration
  def change
  	manager_dashboard_id = Ref::Dashboard[:MANAGER].id
    staff_dashboard_id =  Ref::Dashboard[:FRONT_DESK].id
    housekeeping_dashboard_id = Ref::Dashboard[:HOUSEKEEPING].id

    hotel_admin_role_id = Role.hotel_admin.id
    front_office_staff_role_id = Role.front_office_staff.id
    floor_and_maintenance_staff_role_id = Role.find_by_name('floor_&_maintenance_staff').id

  	execute("UPDATE hotels_roles SET default_dashboard_id=#{manager_dashboard_id} where role_id=#{hotel_admin_role_id}")
  	execute("UPDATE hotels_roles SET default_dashboard_id=#{staff_dashboard_id} where role_id=#{front_office_staff_role_id}")
  	execute("UPDATE hotels_roles SET default_dashboard_id=#{housekeeping_dashboard_id} where role_id=#{floor_and_maintenance_staff_role_id}")
  end
end