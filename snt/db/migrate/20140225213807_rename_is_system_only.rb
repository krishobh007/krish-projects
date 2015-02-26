class RenameIsSystemOnly < ActiveRecord::Migration
  def change
    rename_column :feature_types, :is_system_only, :is_system_features_only
    execute "update feature_types set selection_type = 'dropdown' where selection_type = 'selectbox'"
  end
end
