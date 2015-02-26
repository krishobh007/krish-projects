class AddPreferencesTables < ActiveRecord::Migration
  def change
    create_table :preference_values do |t|
      t.string :preference_type, limit: 40, null: false
      t.string :preference_value, limit: 80, null: false
      t.string :description, limit: 200, null: false
    end
  end
end
