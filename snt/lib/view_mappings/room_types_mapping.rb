class ViewMappings::RoomTypesMapping
  def self.map_room_types(hotel)
    {
      is_import_available: hotel.is_third_party_pms_configured?.to_s,
      room_types: hotel.room_types.map do |room_type| {
        id: room_type.id.to_s,
        code: room_type.room_type,
        name: room_type.room_type_name
        }
      end
    }
  end

  def self.map_new_room_type_params(params, hotel)
    {
      room_type: params['room_type_code'],
      room_type_name: params['room_type_name'],
      description: params['snt_description'],
      max_occupancy: params['max_occupancy'],
      is_pseudo: params['is_pseudo_room_type'].present? ? params['is_pseudo_room_type'] : false,
      is_suite: params['is_suite'].present? ? params['is_suite'] : false,
      hotel_id: hotel.id,
      no_of_rooms: hotel.number_of_rooms
    }
  end

  def self.map_edit_room_type_params(room_type_details)
    {
      room_type_id: room_type_details.id.to_s,
      room_type_code: room_type_details.room_type,
      room_type_name: room_type_details.room_type_name,
      snt_description: room_type_details.description,
      max_occupancy: room_type_details.max_occupancy.to_s,
      is_pseudo_room_type: room_type_details.is_pseudo.to_s,
      is_suite: room_type_details.is_suite.to_s,
      image_of_room_type: room_type_details.image.url(:thumb)
    }
  end

  def self.upsell_options(reservation, options={})
    hotel = reservation.hotel
    business_date = hotel.active_business_date

    rooms = hotel.rooms.exclude_pseudo
    ooo_rooms =  rooms.out_of_order_between(business_date, business_date)
    
    hkstatuses = Ref::HousekeepingStatus.all.map { |r| {id: r.id, value: r.value } }

    if hotel.settings.checkin_inspected_only
      ready_status_ids = hkstatuses.select{|s| s[:value]=='CLEAN'}.map{ |s| s[:id] }
    else
      ready_status_ids = hkstatuses.select{|s| s[:value]=='INSPECTED' || s[:value]=='CLEAN'}.map { |s| s[:id] }
    end

    ooo_rooms =  rooms.out_of_order_between(business_date, business_date)
    ready_rooms = rooms.select {|r| ready_status_ids.include?(r.hk_status_id) }

    assigned_rooms = Room.assigned_rooms(hotel, rooms)
    assigned_reserved_rooms = assigned_rooms.where(is_occupied: false).where('reservations.status_id = ?', Ref::ReservationStatus[:RESERVED].id)
    due_in_rooms = assigned_reserved_rooms.where('reservations.arrival_date = ?', 
                    reservation.arrival_date)
    due_in_room_ids = due_in_rooms.pluck(:id)

    ready_rooms_excluding_due_in =  rooms.where('rooms.id NOT IN (?) AND rooms.id IN (?)', due_in_room_ids, ready_rooms.map{ |r| r.id })
    inactive_rooms = rooms.inactive_between(business_date, business_date).select('rooms.id as room_id, ref_service_status_id')
    inactive_room_ids = inactive_rooms.pluck(:id)
    options_hash = {}
    current_room_type = options[:room_type] || reservation.current_daily_instance.room_type
    options_hash[:current_room_type] = current_room_type
    options_hash[:inactive_room_ids] = inactive_room_ids
    options_hash[:oo_service_status_id] = options[:oo_service_status_id]
    options_hash[:inactive_rooms] = inactive_rooms
    current_room_type.get_upgrade_room_types(reservation).map do |room_type|
      available_room_ids = ready_rooms_excluding_due_in.select{|room| room.room_type_id  == room_type.id}.map { |room| room[:id] } - ooo_rooms.select{|room| room.room_type_id  == room_type.id}.map { |room| room[:id] }
      upgrade_rooms = rooms.select{|room|  room.id == (available_room_ids.first) }if available_room_ids.present?
      upgrade_rooms ? ViewMappings::UpsellMapping.map_upsell_option(reservation, room_type, upgrade_rooms.first, options_hash) : nil
    end.compact

  end
end
