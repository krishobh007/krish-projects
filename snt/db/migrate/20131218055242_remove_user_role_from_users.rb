class RemoveUserRoleFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :user_role
  end

  def down
    add_column :users, :user_role, :string
  end
end
