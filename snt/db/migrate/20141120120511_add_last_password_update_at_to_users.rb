class AddLastPasswordUpdateAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_password_update_at, :datetime
  end
end
