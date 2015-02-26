class UpdateInactiveRoomsTable < ActiveRecord::Migration
  def change
    add_column :inactive_rooms, :date, :date
    # Update existing data in inactive rooms table
    InactiveRoom.all.each do |room|
      (room.from_date..room.to_date).each { |date|
        current_inactive_room = InactiveRoom.find_by_room_id_and_date(room.room_id, date)
          next if current_inactive_room.present?
          InactiveRoom.create!({ room_id: room.room_id, ref_service_status_id: room.ref_service_status_id, 
                               from_date: room.from_date, to_date: room.to_date, 
                               maintenance_reason_id: room.maintenance_reason_id, comments: room.comments,
                               date: date
                             })
       }
       room.destroy
    end
    remove_column :inactive_rooms, :from_date
    remove_column :inactive_rooms, :to_date
  end
end
