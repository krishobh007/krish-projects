class InsertHotelsRoles < ActiveRecord::Migration
  def change
    manager_dashboard_id = Ref::Dashboard[:MANAGER].id
    staff_dashboard_id =  Ref::Dashboard[:FRONT_DESK].id
    housekeeping_dashboard_id = Ref::Dashboard[:HOUSEKEEPING].id

    hotel_admin_role_id = Role.hotel_admin.id
    front_office_staff_role_id = Role.front_office_staff.id
    floor_and_maintenance_staff_role_id = Role.find_by_name('floor_&_maintenance_staff').id
    Hotel.all.each do |hotel|
      @hotel_role = hotel.hotels_roles.find_or_initialize_by_role_id(hotel_admin_role_id)
      @hotel_role.default_dashboard_id = manager_dashboard_id unless @hotel_role.default_dashboard_id
      @hotel_role.save

      @hotel_role = hotel.hotels_roles.find_or_initialize_by_role_id(front_office_staff_role_id)
      @hotel_role.default_dashboard_id = staff_dashboard_id unless @hotel_role.default_dashboard_id
      @hotel_role.save

      @hotel_role = hotel.hotels_roles.find_or_initialize_by_role_id(floor_and_maintenance_staff_role_id)
      @hotel_role.default_dashboard_id = housekeeping_dashboard_id unless @hotel_role.default_dashboard_id
      @hotel_role.save
    end
  end
end
