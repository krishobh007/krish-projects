class CreateFeatureTypes < ActiveRecord::Migration
  def change
    create_table :feature_types do |t|
      t.string :value
      t.string :selection_type
      t.integer :hotel_id , references: :hotels
      t.boolean :hide_on_room_assignment
      t.string :description
      t.timestamps
    end
  end
end
