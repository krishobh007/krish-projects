class RevertCompletionTimeMigration < ActiveRecord::Migration
  def change
    remove_column :room_type_tasks, :completion_time
    add_column :tasks, :completion_time, :datetime
  end
end
