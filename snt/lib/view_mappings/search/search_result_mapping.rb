class ViewMappings::Search::SearchResultMapping
  READY = 'READY'
  NOT_READY = 'NOTREADY'
  extend ApplicationHelper
   # Find all the guest details that are associated with the reservations and put them in a hash
  def self.find_guest_details_hash(reservations)
    guest_detail_ids = reservations.pluck('guest_details.id')
    guest_details = GuestDetail.where(id: guest_detail_ids).select('id, title, avatar_file_name, avatar_updated_at, hotel_chain_id')
    Hash[guest_details.map { |guest_detail| [guest_detail.id, guest_detail] }]
  end

  # Find all the rooms that are associated with the reservations and put them in a hash
  def self.find_rooms_hash(reservations, active_business_date)
    room_ids = reservations.pluck(:room_id)
    rooms = Room.joins(reservation_daily_instances: :reservation)
      .where('rooms.id IN (?) AND reservation_daily_instances.reservation_date = ?', room_ids, active_business_date)
      .select('rooms.id, rooms.hotel_id, reservations.status_id as reservation_status_id, rooms.hk_status_id, reservations.dep_date, '\
              'rooms.is_occupied')

    # Rooms hash needs checked_in status first. If no reservation there is no multiple reservation on same room take only the current one
    rooms_hash = {}
    rooms.each do |room|
      if !rooms_hash[room.id].present? || Ref::ReservationStatus[room.reservation_status_id] === :CHECKEDIN
        rooms_hash[room.id] = room
      end
    end
    rooms_hash
  end
  
  # Construct the results hash array using the search results
  def self.construct_results(reservations, hotel)
    is_late_checkout_on = hotel.settings.late_checkout_is_on
    use_inspected = hotel.settings.use_inspected
    use_pickup = hotel.settings.use_pickup
    is_inspected_only = hotel.settings.checkin_inspected_only
    is_queue_rooms_on = hotel.settings.is_queue_rooms_on
    active_business_date = hotel.active_business_date

   # reservations = find_reservations(query, status, hotel, request_date, is_late_checkout_only, is_queued_rooms_only, is_vip)
    guest_details_hash = find_guest_details_hash(reservations)
    rooms_hash = find_rooms_hash(reservations, active_business_date)

    reservations.map do |reservation|
      room = rooms_hash[reservation.room_id]
      guest_images = []
      guest_detail = guest_details_hash[reservation.guest_detail_id]

      if guest_detail
        guest_images << { is_primary: true, guest_image: guest_detail.andand.avatar.url(:thumb).to_s }

        if reservation.is_accompanying_guest?
          guest_images << {
            is_primary: false,
            guest_image: guest_detail.avatar.url(:thumb).to_s
          }
        end
      end

      result = {
        id: reservation.id,
        confirmation: reservation.confirm_no,
        guest_detail_id: reservation.guest_detail_id,
        room: reservation.room_no,
        group: reservation.group_name,
        city: reservation.city,
        state: reservation.state,
        country: reservation.country_id.present? ? Country.find(reservation.country_id).andand.name : '',
        email: reservation.email.to_s,
        phone: reservation.phone.to_s,
        reservation_status: ViewMappings::StayCardMapping.map_view_status(reservation, active_business_date),
        roomstatus: room.andand.is_ready? ? READY : NOT_READY,
        fostatus: room ? room.mapped_fo_status(due_out?(room, active_business_date)) : '',
        lastname: reservation.last_name,
        firstname: reservation.first_name,
        location: [reservation.city.to_s, reservation.state.to_s].reject { |e| e.empty? }.compact.join(', '),
        vip: reservation.is_vip,
        images: guest_images,
        room_ready_status: room.present? ? room.andand.hk_status.to_s : '',
        is_reservation_queued: reservation.is_queued.to_s
      }

      if is_late_checkout_on
        result[:is_opted_late_checkout] = reservation.is_opted_late_checkout
        result[:late_checkout_time] = reservation.late_checkout_time.andand.strftime('%l:%M %p')
      end

      result[:use_inspected] = use_inspected.to_s
      result[:use_pickup] = use_pickup.to_s
      result[:checkin_inspected_only] = is_inspected_only.to_s
      result[:is_queue_rooms_on] = is_queue_rooms_on.to_s
      result
    end
  end
  
    # Determines if the room is due out based on the reservations status
  def self.due_out?(room, active_business_date)
    room.dep_date == active_business_date && Ref::ReservationStatus[room.reservation_status_id] === :CHECKEDIN
  end
  

end