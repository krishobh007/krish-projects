class CreateAdminMenus < ActiveRecord::Migration
  def change
    create_table :admin_menus do |t|
      t.string :name
      t.string :description, length: 45
      t.integer :display_order
      t.string :available_for, length: 45
      t.references :created_by
      t.references :updated_by
      t.timestamps

    end
  end
end
