class MoveStatusToCmsComponents < ActiveRecord::Migration
  def change
    remove_column :cms_section_components, :status
    add_column :cms_components, :status, :string
  end
end
