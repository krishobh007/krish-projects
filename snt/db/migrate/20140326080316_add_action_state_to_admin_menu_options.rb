class AddActionStateToAdminMenuOptions < ActiveRecord::Migration
  def change
       add_column :admin_menu_options, :action_state ,:string
  end
end
