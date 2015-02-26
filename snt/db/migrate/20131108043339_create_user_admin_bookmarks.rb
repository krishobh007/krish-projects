class CreateUserAdminBookmarks < ActiveRecord::Migration
  def change
    create_table :user_admin_bookmarks do |t|
      t.references :user
      t.references :admin_menu_option
      t.timestamps
    end
  end
end
