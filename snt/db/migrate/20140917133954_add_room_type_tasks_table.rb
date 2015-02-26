class AddRoomTypeTasksTable < ActiveRecord::Migration
  def change
    create_table :room_type_tasks do |t|
      t.references :task
      t.references :room_type
    end
  end
end
