class DeleteInvalidRoles < ActiveRecord::Migration
  def change
  	execute('
             INSERT INTO roles (name)
             SELECT * FROM (SELECT ("revenue_manager")) AS tmp
             WHERE NOT EXISTS
             (SELECT * FROM roles WHERE name = "revenue_manager")
          ')
  	execute("delete from roles WHERE name not in ('admin',
		'hotel_admin',
		'revenue_manager',
		'guest',
		'manager',
		'front_office_staff',
		'reservation_staff',
		'floor_&_maintenance_manager',
		'floor_&_maintenance_staff',
		'accounting_staff',
		'api_user')")
  end
end
