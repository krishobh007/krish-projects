class FixTaskReservationStatusesTable < ActiveRecord::Migration
  def change
    remove_column :task_reservation_statuses, :name
    remove_column :task_reservation_statuses, :created_at
    remove_column :task_reservation_statuses, :updated_at
  end
end
