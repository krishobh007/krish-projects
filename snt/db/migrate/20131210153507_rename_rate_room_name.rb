class RenameRateRoomName < ActiveRecord::Migration
  def change
    rename_column :rates, :name, :rate_name
    remove_column :room_types, :name
  end
end
