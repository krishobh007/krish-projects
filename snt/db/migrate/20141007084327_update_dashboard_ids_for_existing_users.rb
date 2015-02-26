class UpdateDashboardIdsForExistingUsers < ActiveRecord::Migration
  def change
      # As per CICO - CICO-9995, develop branch doesnt have any ref_dashboards table & data
      # As seed running after the migarion, we will insert ther
      # ref_dashboards values first.
      # and updating users tables accordingly.

    Ref::Dashboard.enumeration_model_updates_permitted = true
    Ref::Dashboard.create(value: 'MANAGER', description: 'Manager')
    Ref::Dashboard.create(value: 'FRONT_DESK', description: 'Front Desk')
    Ref::Dashboard.create(value: 'HOUSEKEEPING', description: 'Housekeeping')

    manager_dashboard_id = Ref::Dashboard[:MANAGER].id
    staff_dashboard_id =  Ref::Dashboard[:FRONT_DESK].id
    housekeeping_dashboard_id = Ref::Dashboard[:HOUSEKEEPING].id

    hotel_admin_role_id = Role.hotel_admin.id
    admin_role_id = Role.admin.id
    guest_role_id = Role.guest.id

    # Step -01 Handle Manger Dashboard
    # Find the users with role = hotel_admin
    # Set default dashboard id as manager dashboard ID

    execute("UPDATE users u set u.default_dashboard_id = #{manager_dashboard_id} "\
              "WHERE u.id IN
              (SELECT id from (SELECT usr.id FROM users usr "\
      "INNER JOIN users_roles ON users_roles.user_id = usr.id "\
      "INNER JOIN roles ON roles.id = users_roles.role_id WHERE roles.id = #{hotel_admin_role_id}) as tab)")

    # Step 02  Handle Front office staff
    # Find users with role != admin, role!=hotel_admin,  role!=guest , is_houekeeping_only!=true
    # set default dashboard_id = staff_dashboard_id

    execute("UPDATE users set default_dashboard_id = #{staff_dashboard_id} "\
            "WHERE id IN
             (SELECT id from (SELECT users.id FROM users
              INNER JOIN users_roles ON users_roles.user_id = users.id
              INNER JOIN roles ON roles.id = users_roles.role_id
              WHERE roles.id not in (#{hotel_admin_role_id}, #{admin_role_id}, #{guest_role_id}) and is_housekeeping_only <> true) as tab) ")

    # Step 03  Handle HK staff
    # Find users with is_houekeeping_only = true
    # Set dashboard id = housekeeping_dashboard_id

    execute("UPDATE users set default_dashboard_id = #{housekeeping_dashboard_id} WHERE is_housekeeping_only = true")
  end
end
