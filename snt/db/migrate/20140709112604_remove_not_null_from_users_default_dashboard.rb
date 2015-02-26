class RemoveNotNullFromUsersDefaultDashboard < ActiveRecord::Migration
  def up
    change_column :users, :default_dashboard_id, :integer, null: true

  end

end
