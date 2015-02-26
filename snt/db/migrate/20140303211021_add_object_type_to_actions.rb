class AddObjectTypeToActions < ActiveRecord::Migration
  def change
    add_column :actions, :object_type, :string, null: false
  end
end
