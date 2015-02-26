class AddGroupCodeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :group_code, :string
  end
end
