class CreateUsersRoles < ActiveRecord::Migration
  def change
    create_table :users_roles, id: false do |t|
      t.references :user, null: false, index: true
      t.references :role, null: false, index: true
    end
  end
end
