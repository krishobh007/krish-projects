class AddHideOnRoomAssignmentFlag < ActiveRecord::Migration
  def change
    add_column :ref_feature_types, :hide_on_room_assignment, :boolean
  end
end
