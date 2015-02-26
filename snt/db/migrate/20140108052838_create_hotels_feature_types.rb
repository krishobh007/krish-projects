class CreateHotelsFeatureTypes < ActiveRecord::Migration
  def change
    create_table :hotels_feature_types, id: false do |t|
      t.references :hotel, null: false, index: true
      t.references :feature_type, null: false, index: true
    end
  end
end
