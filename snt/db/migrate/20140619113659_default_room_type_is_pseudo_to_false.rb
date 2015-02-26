class DefaultRoomTypeIsPseudoToFalse < ActiveRecord::Migration
  def change
    execute('update room_types set is_pseudo = false where is_pseudo is null')
    change_column :room_types, :is_pseudo, :boolean, default: false, null: false
  end
end
