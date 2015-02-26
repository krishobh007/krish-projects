class AddIsSystemToWorkType < ActiveRecord::Migration
  def change
    add_column :work_types, :is_system, :boolean, default: false
  end
end
