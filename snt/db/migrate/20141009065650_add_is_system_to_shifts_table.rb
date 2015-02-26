class AddIsSystemToShiftsTable < ActiveRecord::Migration
  def change
    add_column :shifts, :is_system, :boolean, default: false
  end
end
