class AddCompletionTimeToRoomTypeTask < ActiveRecord::Migration
  def change
    add_column :room_type_tasks, :completion_time, :time
    remove_column :tasks, :completion_time
  end
end
