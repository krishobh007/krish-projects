class RenameObjectOnActions < ActiveRecord::Migration
  def change
    rename_column :actions, :object_id, :actionable_id
    rename_column :actions, :object_type, :actionable_type
  end
end
