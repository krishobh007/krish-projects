class AddIndexOnRoomTypeTasks < ActiveRecord::Migration
  def change
    add_index :room_type_tasks, [:task_id, :room_type_id], unique: true
  end
end
