class AddIsSystemToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :is_system, :boolean, default: false
  end
end
