class AddRoomTypeNameRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :room_type_name, :string
  end
end
