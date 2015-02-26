class FixFrontOfficeStatusTasksTable < ActiveRecord::Migration
  def change
    remove_column :front_office_statuses_tasks, :created_at
    remove_column :front_office_statuses_tasks, :updated_at
  end
end
