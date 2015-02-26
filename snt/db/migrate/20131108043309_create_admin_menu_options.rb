class CreateAdminMenuOptions < ActiveRecord::Migration
  def change
    create_table :admin_menu_options do |t|
      t.string :name
      t.boolean :is_group, default: false
      t.string :icon_url
      t.string :action_path
      t.references :admin_menu
      t.integer :parent_id
      t.references :created_by
      t.references :updated_by
      t.timestamps
    end
  end
end
