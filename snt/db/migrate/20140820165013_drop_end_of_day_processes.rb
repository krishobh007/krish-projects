class DropEndOfDayProcesses < ActiveRecord::Migration
  def change
    drop_table :end_of_day_processes
  end
end
