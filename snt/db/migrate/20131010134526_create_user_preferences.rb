class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.string :preference_type
      t.string :preference_value
      t.string :description
      t.references :user
      t.references :preference
      t.timestamps
    end
  end
end
