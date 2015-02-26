class UpdateExternalReferencesPmsType < ActiveRecord::Migration
  def up
    add_column :external_references, :pms_type_id, :integer
    remove_column :external_references, :external_system
  end

  def down
    remove_column :external_references, :pms_type_id
    add_column :external_references, :external_system, :string
  end
end
