class AddDefaultValueRoomTypes < ActiveRecord::Migration
  def change
     change_column :room_types, :is_pseudo, :boolean, :default => 0
     change_column :room_types, :is_suite, :boolean, :default => 0
  end
end
