class AddTasksTable < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.references :work_type
      t.references :room_type
      t.references :ref_housekeeping_status
      t.boolean :is_occupied
      t.boolean :is_vacant
      t.datetime :completion_time
      t.timestamps
    end
  end
end
