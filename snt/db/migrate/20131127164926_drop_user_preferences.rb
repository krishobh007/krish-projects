class DropUserPreferences < ActiveRecord::Migration
  def up
    drop_table :user_preferences
  end

  def down
    create_table :user_preferences do |t|
      t.string :preference_type
      t.string :preference_value
      t.string :description
      t.references :user
      t.references :preference
      t.timestamps
      t.userstamps
    end
  end
end
