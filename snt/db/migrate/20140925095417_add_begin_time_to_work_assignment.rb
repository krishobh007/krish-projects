class AddBeginTimeToWorkAssignment < ActiveRecord::Migration
  def change
    add_column :work_assignments, :begin_time, :datetime
    add_column :work_assignments, :end_time, :datetime
  end
end
