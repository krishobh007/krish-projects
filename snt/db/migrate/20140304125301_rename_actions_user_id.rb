class RenameActionsUserId < ActiveRecord::Migration
  def change
    rename_column :actions, :user_id, :creator_id
  end
end
