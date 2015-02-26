class AddWorkAssignmentIndexes < ActiveRecord::Migration
  def change
    add_index :tasks, :work_type_id

    add_index :task_reservation_statuses, [:task_id, :ref_reservation_hk_status_id], name: 'idx_task_res_status'

    execute 'delete a from task_reservation_statuses a, task_reservation_statuses b where a.id < b.id and a.task_id = b.task_id ' \
            'and a.ref_reservation_hk_status_id = b.ref_reservation_hk_status_id'

    remove_index :task_reservation_statuses, name: 'idx_task_res_status'
    add_index :task_reservation_statuses, [:task_id, :ref_reservation_hk_status_id], unique: true, name: 'idx_task_res_status_uniq'

    add_index :rooms, :room_type_id
    add_index :work_assignments, :room_id
    add_index :work_assignments, :work_sheet_id
    add_index :work_sheets, [:work_type_id, :date]
    add_index :work_sheets, :user_id
  end
end
