class AddUsersColumns < ActiveRecord::Migration
  def change
    add_column :users, :language, :string
    add_column :users, :nationality, :string
    add_column :users, :passport_no, :string
    add_column :users, :passport_expiry, :date
  end
end
