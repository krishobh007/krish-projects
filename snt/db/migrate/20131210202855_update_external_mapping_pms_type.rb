class UpdateExternalMappingPmsType < ActiveRecord::Migration
  def up
    add_column :external_mappings, :pms_type_id, :integer
    remove_column :external_mappings, :external_system
  end

  def down
    remove_column :external_mappings, :pms_type_id
    add_column :external_mappings, :external_system, :string
  end
end
