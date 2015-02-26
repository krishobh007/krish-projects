class AddWorkAssignmentsTable < ActiveRecord::Migration
  def change
    create_table :work_assignments do |t|
      t.references :work_sheet
      t.references :task
      t.references :room
      t.references :work_status
      t.integer :order
    end
  end
end
