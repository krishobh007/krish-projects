class AddDefaultDashboardIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_dashboard_id, :integer
  end
end
