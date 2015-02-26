class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.references :user, null: false
      t.references :hotel, null: false
      t.references :action_type, null: false
      t.references :application, null: false
      t.references :object, polymorhpic: true, null: false
      t.timestamps
    end

    add_index :actions, [:hotel_id, :action_type_id]
  end
end
