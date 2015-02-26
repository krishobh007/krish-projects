class CreatePreferences < ActiveRecord::Migration
  def change
    create_table :preferences do |t|
      t.string :preference_type
      t.string :preference_value
      t.boolean :is_system_value
      t.references :hotel
      t.references :hotel_chain
      t.timestamps
    end
  end
end
