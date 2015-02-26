class AddValidBranchCountToCmsComponents < ActiveRecord::Migration
  def change
    add_column :cms_components, :valid_branch_count, :integer, default: 0
  end
  
end
