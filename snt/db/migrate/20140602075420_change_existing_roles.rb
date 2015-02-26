class ChangeExistingRoles < ActiveRecord::Migration
  def change
    execute('
             INSERT INTO roles (name)
             SELECT * FROM (SELECT ("manager")) AS tmp
             WHERE NOT EXISTS
             (SELECT * FROM roles WHERE name = "manager")
          ')
    execute('
             INSERT INTO roles (name)
             SELECT * FROM (SELECT ("front_office_staff")) AS tmp
             WHERE NOT EXISTS
             (SELECT * FROM roles WHERE name = "front_office_staff")
          ')
    execute('
             INSERT INTO roles (name)
             SELECT * FROM (SELECT ("reservation_staff")) AS tmp
             WHERE NOT EXISTS
             (SELECT * FROM roles WHERE name = "reservation_staff")
          ')
    execute('
             INSERT INTO roles (name)
             SELECT * FROM (SELECT ("floor_&_maintenance_manager")) AS tmp
             WHERE NOT EXISTS
             (SELECT * FROM roles WHERE name = "floor_&_maintenance_manager")
          ')
    execute('
             INSERT INTO roles (name)
             SELECT * FROM (SELECT ("floor_&_maintenance_staff")) AS tmp
             WHERE NOT EXISTS
             (SELECT * FROM roles WHERE name = "floor_&_maintenance_staff")
          ')
    execute('
             INSERT INTO roles (name)
             SELECT * FROM (SELECT ("accounting_staff")) AS tmp
             WHERE NOT EXISTS
             (SELECT * FROM roles WHERE name = "accounting_staff")
          ')
    execute("UPDATE users_roles SET role_id=(SELECT id from roles WHERE name = 'front_office_staff')
             WHERE role_id=(SELECT id from roles WHERE name = 'front_desk_staff' LIMIT 1)")
    execute("UPDATE users_roles SET role_id=(SELECT id from roles WHERE name = 'manager')
             WHERE role_id=(SELECT id from roles WHERE name = 'front_desk_management' LIMIT 1)")
    execute("UPDATE users_roles SET role_id=(SELECT id from roles WHERE name = 'front_office_staff')
             WHERE role_id=(SELECT id from roles WHERE name = 'hotel_staff' LIMIT 1)")
    execute('delete from roles WHERE name in ("hotel_staff", "front_desk_staff", "front_desk_management")')
  end
end
