class AddOldPasswordsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :old_passwords, :text
  end

  def down
    remove_column :users, :old_passwords
  end
end
