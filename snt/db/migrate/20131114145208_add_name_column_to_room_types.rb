class AddNameColumnToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :name, :string
  end
end
