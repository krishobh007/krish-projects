class CreateRefFeatureTypes < ActiveRecord::Migration
  def change
    create_table :ref_feature_types do |t|
      t.string :name, null: false
      t.string :selection_type, null: false
      t.boolean :is_system_type, null: false
      t.timestamps
      t.userstamps
    end
  end
end
