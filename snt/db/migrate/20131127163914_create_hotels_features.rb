class CreateHotelsFeatures < ActiveRecord::Migration
  def change
    create_table :hotels_features, id: false do |t|
      t.references :feature, null: false, index: true
      t.references :hotel, null: false, index: true
    end
  end
end
