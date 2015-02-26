class AddIsSuiteToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :is_suite, :boolean
  end
end
