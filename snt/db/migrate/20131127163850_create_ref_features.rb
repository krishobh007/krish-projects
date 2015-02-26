class CreateRefFeatures < ActiveRecord::Migration
  def change
    create_table :ref_features do |t|
      t.references :ref_feature_type, null: false
      t.string :value, null: false
      t.string :description
      t.timestamps
      t.userstamps
    end
  end
end
