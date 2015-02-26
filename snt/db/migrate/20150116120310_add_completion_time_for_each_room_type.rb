class AddCompletionTimeForEachRoomType < ActiveRecord::Migration
  def change
    add_column :room_type_tasks, :completion_time, :datetime
  end
end
