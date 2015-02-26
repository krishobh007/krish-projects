class RemoveIconImageColumnsFromCmsComponents < ActiveRecord::Migration
  def change
    remove_column :cms_components, :icon_file_name
    remove_column :cms_components, :icon_content_type
    remove_column :cms_components, :icon_file_size
    remove_column :cms_components, :image_file_name
    remove_column :cms_components, :image_content_type
    remove_column :cms_components, :image_file_size
  end
end
