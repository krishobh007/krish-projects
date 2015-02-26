class RenameComponentNameTypeInCmsComponents < ActiveRecord::Migration
  def change
    rename_column :cms_components, :component_name, :name
    rename_column :cms_components, :component_type, :type
  end
end
