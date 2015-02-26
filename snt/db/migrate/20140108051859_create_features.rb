class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :value
      t.string :description
      t.integer :hotel_id
      t.integer :feature_type_id, references: :feature_types
      t.timestamps
    end
  end
end
