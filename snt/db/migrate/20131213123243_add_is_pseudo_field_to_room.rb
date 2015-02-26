class AddIsPseudoFieldToRoom < ActiveRecord::Migration
  def up
    add_column :rooms, :is_pseudo, :boolean, default: false
  end

  def down
    remove_column :rooms, :is_pseudo
  end
end
