class CreateActionDetails < ActiveRecord::Migration
  def change
    create_table :action_details do |t|
      t.references :action, null: false
      t.string :key, null: false
      t.string :old_value
      t.string :new_value
    end

    add_index :action_details, [:action_id, :key], unique: true
  end
end
