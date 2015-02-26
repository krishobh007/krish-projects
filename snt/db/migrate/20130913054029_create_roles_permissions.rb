class CreateRolesPermissions < ActiveRecord::Migration
  def change
    create_table :roles_permissions do |t|
      t.integer :entity_id
      t.integer :role_id
      t.integer :permission_id
      t.boolean :value
      t.timestamps
    end
    add_index :roles_permissions, :entity_id
    add_index :roles_permissions, :role_id
    add_index :roles_permissions, :permission_id
  end
end
