class ChangeTablesForSchemaRedesign < ActiveRecord::Migration
  def change
    add_column :membership_levels, :membership_type_id, :integer
  end
end
