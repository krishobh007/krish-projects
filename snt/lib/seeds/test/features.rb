module SeedTestFeatures
  def create_test_features
    hotel = Hotel.find_by_code('DOZERQA')

    room_feature_type = FeatureType.where(value: 'ROOM FEATURE', selection_type: 'checkbox', hotel_id: nil).first
    floor_type = FeatureType.where(value: 'FLOOR', selection_type: 'radio', hotel_id: nil).first
    smoking_type = FeatureType.where(value: 'SMOKING', selection_type: 'radio', hotel_id: nil).first
    elevator_type = FeatureType.where(value: 'ELEVATOR', selection_type: 'radio', hotel_id: nil).first
    newspaper_type = FeatureType.where(value: 'NEWSPAPER', selection_type: 'dropdown', hotel_id: nil, hide_on_room_assignment: true).first
    room_type = FeatureType.where(value: 'ROOM TYPE', selection_type: 'dropdown', hotel_id: nil, hide_on_room_assignment: true).first

    Feature.create(value: 'BALCONY', description: 'Balcony', feature_type_id: room_feature_type.id, hotel_id: hotel.id)
    Feature.create(value: 'CONNECTING ROOM', description: 'Connecting Room', feature_type_id: room_feature_type.id, hotel_id: hotel.id)
    Feature.create(value: 'SPA', description: 'Spa Bath in room', feature_type_id: room_feature_type.id, hotel_id: hotel.id)

    Feature.create(value: 'BOSTON HERALD', description: 'Boston Herald', feature_type_id: newspaper_type.id, hotel_id: hotel.id)
    Feature.create(value: 'CROATIAN TIMES', description: 'Croatian Times', feature_type_id: newspaper_type.id, hotel_id: hotel.id)
    Feature.create(value: 'SUEDDEUTSCHE ZEITUNG', description: 'Sueddeutsche Zeitung', feature_type_id: newspaper_type.id, hotel_id: hotel.id)
    Feature.create(value: 'SYDNEY MORNING HERALD', description: 'Sydney Morning Herald', feature_type_id: newspaper_type.id, hotel_id: hotel.id)
    Feature.create(value: 'USA TODAY', description: 'USA Today', feature_type_id: newspaper_type.id, hotel_id: hotel.id)

    hotel.features = Feature.for_hotel_or_system(hotel)
    hotel.save

    guest = GuestDetail.first
    guest.preferences = Feature.where('value in (?)', ['POOL VIEW', 'BAL', 'TERRACE', 'HIGH', 'NON SMOKING', 'BBC', 'KING TYPE'])
    guest.save

    hotel.rooms.each_with_index do |room, index|
      room.features = Feature.where('value in (?)', ['TERRACE', 'LOW', 'BAL', 'CON', 'SPA', 'SMOKING', 'BBC', 'BH', 'SZ', 'USA', 'KING TYPE']) if index % 3 == 0
      room.features = Feature.where('value in (?)', ['POOL VIEW', 'HIGH', 'SPA', 'BH', 'CT', 'SMH', 'SMOKING', 'BBC', 'KING TYPE']) if index % 3 == 1
      room.features = Feature.where('value in (?)', ['POOL VIEW', 'HIGH', 'CON', 'SPA', 'NON-SMOKING', 'TIMES OF INDIA', 'SZ', 'USA', 'QUEEN TYPE']) if index % 3 == 2
      room.save
    end
  end
end
