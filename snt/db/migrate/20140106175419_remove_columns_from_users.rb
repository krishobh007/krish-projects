class RemoveColumnsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :language_id
    remove_column :users, :nationality
    remove_column :users, :avatar_id
    remove_column :users, :phone
    remove_column :users, :loc
    remove_column :users, :city
  end
end
