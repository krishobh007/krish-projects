class ChangeActionsToAllowNullCreator < ActiveRecord::Migration
  def change
    change_column :actions, :creator_id, :integer, null: true
  end
end
