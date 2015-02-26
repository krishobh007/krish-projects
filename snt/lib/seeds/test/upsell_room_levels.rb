module SeedTestUpsellRoomLevels
  def create_test_upsell_room_levels
=begin  ##This seed data is only required for mobile team for testing. Uncommenting and running it before the import process will cause problem since room types will not be available.
    UpsellRoomLevel.create(
       :level =>1,
       :room_type_id => RoomType.find_by_room_type("STTD").id
       )
       UpsellRoomLevel.create(
       :level =>1,
       :room_type_id => RoomType.find_by_room_type("STDK").id
       )
       UpsellRoomLevel.create(
       :level =>2,
       :room_type_id => RoomType.find_by_room_type("2STE").id
       )
       UpsellRoomLevel.create(
       :level =>3,
       :room_type_id => RoomType.find_by_room_type("DLK").id
       )
       UpsellRoomLevel.create(
       :level =>3,
       :room_type_id => RoomType.find_by_room_type("DLT").id
       )
=end
  end
end
