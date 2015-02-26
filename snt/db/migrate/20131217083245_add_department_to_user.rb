class AddDepartmentToUser < ActiveRecord::Migration
  def up
    add_column :users, :department_id, :integer
  end

  def down
    remove_column :users, :department_id
  end
end
