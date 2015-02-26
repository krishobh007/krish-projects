class UpdateRefFeatureTypeColumns < ActiveRecord::Migration
  def change
    rename_column :ref_feature_types, :name, :value
    add_column :ref_feature_types, :description, :string
    rename_column :ref_features, :ref_feature_type_id, :feature_type_id
  end
end
