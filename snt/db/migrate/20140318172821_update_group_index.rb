class UpdateGroupIndex < ActiveRecord::Migration
  def change
    remove_index :groups, [:name, :hotel_id]
    add_index :groups, [:group_code, :hotel_id]
  end
end
