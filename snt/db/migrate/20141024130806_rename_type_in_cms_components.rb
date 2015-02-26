class RenameTypeInCmsComponents < ActiveRecord::Migration
  def change
    rename_column :cms_components, :type, :component_type
  end
end
