class AddUserIdSessions < ActiveRecord::Migration
  def up
    add_column :sessions, :user_id, :integer
  end

  def down
    remove_column :sessions, :user_id, :integer
  end
end
