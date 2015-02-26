class RenameReferenceValuesTypeReferenceType < ActiveRecord::Migration
  def change
    rename_column :reference_values, :type, :reference_type
   end
end
