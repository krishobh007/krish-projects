# Used to process room status in a remote API
class RoomApi < ConnectEngineApi
  # Get the room status information for the hotel
  def get_room_status(room_type_id, room_no)
    @connect_api_class.get_room_status(@hotel_id, room_type_id, room_no)
  end

  def get_rooms(room_type_code = nil)
    @connect_api_class.get_rooms(@hotel_id, room_type_code)
  end

  def change_room_status(hk_status, room_no)
    @connect_api_class.change_room_status(@hotel_id, hk_status, room_no)
  end
end
