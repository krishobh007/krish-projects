class DropRefFeaturesTable < ActiveRecord::Migration
  def up
    drop_table :ref_feature_types
    drop_table :ref_features
  end
end
