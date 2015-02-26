class ChangeColumnStatusInCmsComponents < ActiveRecord::Migration
  def change
    change_column :cms_components, :status, :boolean, default: true 
  end
end