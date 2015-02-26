class AddTaskReservationStatusTable < ActiveRecord::Migration
  def change
    create_table :task_reservation_statuses do |t|
      t.string :name
      t.references :task
      t.references :ref_reservation_hk_status
      t.timestamps
    end
  end
end
