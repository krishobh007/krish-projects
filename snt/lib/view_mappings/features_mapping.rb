class ViewMappings::FeaturesMapping
  # Maps the room type and feature filters for the room assignment view
  def self.map_room_filters(reservation, current_hotel, is_allow_previous_room_types = false)
    t1 = Time.now
    current_room_type = reservation.current_daily_instance.room_type
    level = current_room_type.upsell_room_level.andand.level
    puts "self.map_room_filters() -- current_room_type& level --(in ms) -- #{(Time.now - t1)*1000}"
    # Get list of room types in the same level if no upsell is applied yet. Otherwise, only return this room's room type.
    if reservation.hotel.is_third_party_pms_configured?
      t3 = Time.now
      
      room_types = level && ( is_allow_previous_room_types ? true : !reservation.is_upsell_applied ) ? current_hotel.room_types.is_not_pseudo.with_level(level).order(:description) :
                                                            [current_room_type].delete_if { |obj| obj.is_pseudo }
      puts "self.map_room_filters() -- current_room_type& level --(in ms) -- #{(Time.now - t3)*1000}"                                                      
    else
      room_types = level ? current_hotel.room_types.is_not_pseudo.with_level(level).order(:description) :
                           [current_room_type].delete_if { |obj| obj.is_pseudo }
    end

    t4 = Time.now
    features = current_hotel.features
    
    puts "self.map_room_filters() -- after current hotel features --(in ms) -- #{(Time.now - t4)*1000}"
    t5 = Time.now
    feature_types = features.map { |feature| feature.feature_type }.select { |feature_type| !feature_type.hide_on_room_assignment }
      .sort { |a, b| a.value <=> b.value }.uniq
    puts "self.map_room_filters() -- after feature_types --(in ms) -- #{(Time.now - t5)*1000}"  
    t6 = Time.now
    guest_features = reservation.primary_guest.andand.preferences || []
    puts "self.map_room_filters() -- after guest features --(in ms) -- #{(Time.now - t6)*1000}"  
    t7 = Time.now
    {
      'room_types' => room_types.map do |room_type|
        {
          'id' => room_type.id,
          'description' => room_type.room_type_name,
          'type' => room_type.room_type
        }
      end,
      'room_features' => feature_types.map do |feature_type|
        {
          'group_name' => feature_type.value,
          'multiple_allowed' => feature_type.selection_type == 'checkbox',
          'items' => features.select { |feature| feature.feature_type === feature_type }.sort { |a, b| a.value <=> b.value }.map do |feature|
            {
              'id' => feature.id,
              'name' => feature.value,
              'selected' => guest_features.include?(feature)
            }
          end
        }
      end
    }

  end
end
