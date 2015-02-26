class ChangeDescriptionInRoomTypes < ActiveRecord::Migration
  def change
    change_column :room_types, :description, :text
  end
end
