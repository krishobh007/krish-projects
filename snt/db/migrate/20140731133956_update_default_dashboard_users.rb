class UpdateDefaultDashboardUsers < ActiveRecord::Migration
  def change
    execute("update users
            inner join users_roles on users_roles.user_id = users.id
            inner join roles on roles.id = users_roles.role_id
            set default_dashboard_id = (select id from ref_dashboards where value = 'FRONT_DESK')
            where roles.name != 'guest' and default_dashboard_id is null")
  end
end
