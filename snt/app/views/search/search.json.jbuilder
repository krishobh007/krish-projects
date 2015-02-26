json.status 'success'
json.errors nil
is_late_checkout_on = @hotel.settings.late_checkout_is_on
use_inspected = @hotel.settings.use_inspected
use_pickup = @hotel.settings.use_pickup
is_inspected_only = @hotel.settings.checkin_inspected_only
is_queue_rooms_on = @hotel.settings.is_queue_rooms_on
active_business_date = @hotel.active_business_date
json.data do 
  json.results @data[:reservations] do |reservation|
    room = @data[:rooms_hash][reservation.room_id]
    guest_images = []
    guest_detail = @data[:guest_details_hash][reservation.guest_detail_id]
    address = @data[:address_hash][reservation.guest_detail_id]
    if guest_detail
      guest_images << { is_primary: true, guest_image: guest_detail.avatar.andand.url(:thumb).to_s }


      if reservation.is_primary_guest == 0
        guest_images << {
          is_primary: false,
          guest_image: guest_detail.avatar.andand.url(:thumb).to_s
        }
      end
    else
      guest_images << { is_primary: true, guest_image: @avatar_trans_url }
    end

  status = @data[:hk_statuses].as_json.find { |h| h['id'] == room.andand.hk_status_id }
  room_status = status['value'] if status
  if is_inspected_only
    ready_status = (room_status == 'INSPECTED') && (!room.andand.is_occupied)
  else
    ready_status = (room_status == 'INSPECTED' || room_status == 'CLEAN') && (!room.andand.is_occupied)
  end

  arrival_time = reservation.arrival_time.in_time_zone(reservation.hotel.tz_info).strftime('%H:%M') if reservation.arrival_time
  departure_time = reservation.departure_time.in_time_zone(reservation.hotel.tz_info).strftime('%H:%M') if reservation.departure_time
  location = [address.andand.city.to_s, address.andand.state.to_s].reject { |e| e.empty? }.compact.join(', ')
  json.id reservation.id
  json.confirmation reservation.confirm_no
  json.guest_detail_id reservation.guest_detail_id
  json.room reservation.room_no
  json.group reservation.group_name
  json.reservation_status ViewMappings::StayCardMapping.map_view_status(reservation, active_business_date)
  json.roomstatus room && ready_status ? 'READY' : 'NOT READY'

  due_out = reservation.dep_date == active_business_date && Ref::ReservationStatus[reservation.status_id] === :CHECKEDIN

  
  if due_out
    fo_status = Setting.room_fo_status[:dueout]
  else
    fo_status = room.andand.is_occupied ? @data[:occupied_status] : @data[:vacant_status]
  end
  

  json.fostatus room ? fo_status : ''
  json.lastname reservation.last_name
  json.firstname reservation.first_name
  json.location location
  json.vip reservation.is_vip
  json.images guest_images
  json.is_accompanying_guest !(reservation.is_primary_guest == 1)
  json.room_ready_status room.present? ? room.andand.hk_status.to_s : ''
  json.room_service_status room.service_status_on(@hotel.active_business_date) if room
  json.is_reservation_queued reservation.is_queued.to_s
  json.is_pre_checkin  reservation.is_pre_checkin
  json.company			reservation.company_account_name.to_s
  json.travel_agent		reservation.travel_agent_account_name.to_s
  json.arrival_date 	reservation.arrival_date
  json.departure_date 	reservation.dep_date
  json.arrival_time		arrival_time
  json.departure_time	departure_time
	
	
  if is_late_checkout_on
    json.is_opted_late_checkout reservation.is_opted_late_checkout
    json.late_checkout_time reservation.late_checkout_time.andand.strftime('%l:%M %p')
  end

  json.use_inspected use_inspected.to_s
  json.use_pickup use_pickup.to_s
  json.checkin_inspected_only is_inspected_only.to_s
  json.is_queue_rooms_on is_queue_rooms_on.to_s
  
 end
 json.total_count @data[:total_count]
end
 