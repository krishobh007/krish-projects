class RemovePseudoFieldFromRoom < ActiveRecord::Migration
  def up
    remove_column :rooms, :is_pseudo
    add_column :room_types, :is_pseudo, :boolean, default: false
  end

  def down
    add_column :rooms, :is_pseudo, :boolean, default: false
    remove_column :room_types, :is_pseudo
  end
end
