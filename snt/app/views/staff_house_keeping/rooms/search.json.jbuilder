json.data do
  json.checkin_inspected_only current_hotel.settings.checkin_inspected_only.to_s
  json.is_queue_rooms_on current_hotel.settings.is_queue_rooms_on.to_s
  json.use_inspected current_hotel.settings.use_inspected.to_s
  json.use_pickup current_hotel.settings.use_pickup.to_s

  json.rooms @rooms do |room|
    json.id room.id
    json.room_no room.room_no
    json.is_occupied room.is_occupied.to_s
    json.is_ready room.is_ready?

    service_status_id = room.service_status

    json.room_reservation_hk_status service_status_id

    json.service_status do
      json.id service_status_id
      json.value Ref::ServiceStatus[service_status_id].value
    end

    json.floor do
      floor = room.floor

      json.id floor.andand.id
      json.floor_number floor.andand.floor_number
    end

    json.room_type do
      room_type = room.room_type

      json.id room_type.id
      json.name room_type.room_type_name
    end

    json.hk_status do
      status = room.hk_status

      json.value status.value
      json.description status.description
      json.oo_status ['OO', 'OS'].include?(status.value) ? 'DIRTY' : nil
    end

    reservations = @reservations.select { |reservation| reservation.room_id == room.id }

    reservation1 = reservations.first
    reservation2 = reservations[1] if reservations.count >= 2

    json.departure_time reservation1.andand.departure_time.andand.in_time_zone(room.hotel.tz_info).andand.strftime("%I:%M %P")
    json.arrival_time (reservation2 || reservation1).andand.arrival_time.andand.in_time_zone(room.hotel.tz_info).andand.strftime("%I:%M %P")
    json.is_queued reservation1.andand.is_queued || reservation2.andand.is_queued || false
    json.is_late_checkout reservation1.andand.is_opted_late_checkout.to_s
    json.late_checkout_time reservation1.andand.late_checkout_time.andand.strftime('%l:%M %p').to_s

    json.room_reservation_status room.front_office_status_for_reservations(reservations)

    primary_guest = @guests.find { |guest| guest.id == reservation1.andand.guest_detail_id }

    json.avatar_src primary_guest.andand.avatar.andand.url(:thumb).to_s
    json.is_vip primary_guest.andand.is_vip.to_s

    work_sheet = room.work_sheets.where(:date => @date).first

    json.assignee_maid do
      assignee = work_sheet.andand.user

      json.id assignee.andand.id
      json.name assignee.andand.full_name
    end

    json.work_sheet_id work_sheet.andand.id
    json.work_type_ids room.room_type.andand.tasks.group(:work_type_id).pluck(:work_type_id)
  end

  json.total_count @rooms.total_count
end

json.status 'success'
json.errors []
