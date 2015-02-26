module SeedRolesPermissions
  def create_roles_permissions
    # To be replaced accordingly after discussion
    all_role_permissions = [
      'Access Dashboard',
      'Access Search',
      'Access Help',
      'Access Stay Card'
    ]

    hotel_admin_permissions = [
      'Manage Users',
      'Manage Roles',
      'Manage Permissions',
      'Manage Hotels',
      'Access Promotions',
      'Access Jobs'
    ]

    front_office_staff_permissions = [
      'Manage Reservation Card',
      'Manage Room Assignment',
      'Manage Stay Dates',
      'Manage Addons',
      'Manage Guest Card',
      'Checkin Guest',
      'Access Guest Bill',
      'Checkout Guest'
    ]

    manager_permissions = [
      'Access Review',
      'Add New Reservation',
      'Upgrade Rooms',
      'Delete Room Assignment',
      'Delete Credit Card',
      'Edit / Delete Note',
      'Cancel Reservation',
      'Manage Vip Status',
      'Manage Rate Discount',
      'Manage Rate Plan',
      'Manage Billing Rules',
      'Delete Charges',
      'Checkout Guest With Balance'
    ]

    snt_admin_permissions = [
      'Manage Brands',
      'Manage Chains'
    ]
    all_role_permissions.each do |value|
      permission = Permission.find_or_create_by_name value
      # Insert permission to all roles
      Role.all.each do |role|
        RolePermission.create(permission_id: permission.id, role_id: role.id, value: 1)
      end
    end

    hotel_admin_permissions.each do |value|
      permission = Permission.find_or_create_by_name value
      RolePermission.create(permission_id: permission.id, role_id: Role.hotel_admin.id, value: 1)
    end

    front_office_staff_permissions.each do |value|
      permission = Permission.find_or_create_by_name value
      RolePermission.create(permission_id: permission.id, role_id: Role.front_office_staff.id, value: 1)
      RolePermission.create(permission_id: permission.id, role_id: Role.manager.id, value: 1)
      RolePermission.create(permission_id: permission.id, role_id: Role.hotel_admin.id, value: 1)
    end

    manager_permissions.each do |value|
      permission = Permission.find_or_create_by_name value
      RolePermission.create(permission_id: permission.id, role_id: Role.manager.id, value: 1)
      RolePermission.create(permission_id: permission.id, role_id: Role.hotel_admin.id, value: 1)
    end

    snt_admin_permissions.each do |value|
      permission = Permission.find_or_create_by_name value
      RolePermission.create(permission_id: permission.id, role_id: Role.admin.id, value: 1)
    end
  end
end
