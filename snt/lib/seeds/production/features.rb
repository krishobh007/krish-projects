module SeedFeatures
  def create_features
    room_feature_type = FeatureType.where(value: 'ROOM FEATURE', selection_type: 'checkbox', hotel_id: nil).first_or_create
    floor_type = FeatureType.where(value: 'FLOOR', selection_type: 'radio', hotel_id: nil, is_system_features_only: true).first_or_create
    smoking_type = FeatureType.where(value: 'SMOKING', selection_type: 'radio', hotel_id: nil, is_system_features_only: true).first_or_create
    elevator_type = FeatureType.where(value: 'ELEVATOR', selection_type: 'radio', hotel_id: nil, is_system_features_only: true).first_or_create
    newspaper_type = FeatureType.where(value: 'NEWSPAPER', selection_type: 'dropdown', hotel_id: nil, hide_on_room_assignment: true).first_or_create
    room_type = FeatureType.where(value: 'ROOM TYPE', selection_type: 'dropdown', hotel_id: nil, hide_on_room_assignment: true).first_or_create

    Feature.create(value: 'HIGH FLOOR', feature_type_id: floor_type.id)
    Feature.create(value: 'LOW FLOOR', feature_type_id: floor_type.id)
    Feature.create(value: 'NEAR ELEVATOR', feature_type_id: elevator_type.id)
    Feature.create(value: 'AWAY FROM ELEVATOR', feature_type_id: elevator_type.id)
    Feature.create(value: 'SMOKING', feature_type_id: smoking_type.id)
    Feature.create(value: 'NON-SMOKING', feature_type_id: smoking_type.id)
  end
end
