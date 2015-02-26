class Room < ActiveRecord::Base
  attr_accessible :hotel_id, :room_no, :room_type_id, :floor, :hk_status, :hk_status_id, :is_occupied, :image_file_name, :image_content_type,
                  :image_file_size, :image, :floor_id, :max_occupancy

  belongs_to :hotel
  belongs_to :room_type
  has_and_belongs_to_many :features, uniq: true, class_name: 'Feature', join_table: 'rooms_features', association_foreign_key: 'feature_id'
  has_many :reservation_daily_instances

  has_many :work_assignments
  has_many :tasks, through: :work_assignments
  has_many :work_sheets, through: :work_assignments

  has_many :inactive_rooms
  belongs_to :floor
  has_many :pre_reservations

  has_enumerated :hk_status, class_name: 'Ref::HousekeepingStatus'

  validates :hotel_id, :room_no, :room_type_id, presence: true
  validates :room_no, uniqueness: { scope: [:hotel_id], case_sensitive: false }
  validates :max_occupancy, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  after_save :room_ready_notification

  has_attached_file :image, styles: { medium: '300x300>', thumb: '100x100>' }, path: ':class/:id/:attachment/:style/:filename',
                            default_url: :get_default_room_image

  # Scope for exclude Pseudo Rooms.
  scope :exclude_pseudo, -> { joins(:room_type).where('room_types.is_pseudo = false') }
  scope :exclude_pseudo_and_suite, -> { joins(:room_type).where('room_types.is_pseudo = false and room_types.is_suite = false') }
  scope :exclude_out_of_service, -> { exclude_hk_status(:OS, :OO) }
  scope :ready, proc { |is_inspected|
    if is_inspected
      with_hk_status(:INSPECTED).where(is_occupied: false)
    else
      with_hk_status(:INSPECTED, :CLEAN).where(is_occupied: false)
    end
  }

  # Scope for Calculating InHouse Room Count
  scope :in_house, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where(is_occupied: true)
    .where('res.status_id=? AND res.dep_date > ?',
           Ref::ReservationStatus[:CHECKEDIN],  request_date)
  }

  # Scope for Calculating Due Out Room Count
  scope :due_out, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where(is_occupied: true)
    .where('res.status_id=? AND res.dep_date = ?',
           Ref::ReservationStatus[:CHECKEDIN],  request_date)
  }

  # Scope for Calculating Due Out Room Count
  scope :due_out_checked_out, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where('(res.status_id=? or res.status_id = ?) AND res.dep_date = ?',
           Ref::ReservationStatus[:CHECKEDIN],  Ref::ReservationStatus[:CHECKEDOUT], request_date)
  }

  # Scope for Calculating Actual Due Out Room Count
  scope :due_out_already, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where('res.status_id=? AND res.dep_date = ?',
           Ref::ReservationStatus[:CHECKEDOUT],  request_date)
  }

  # Scope for Calculating Expected Due In Room Count
  scope :due_in, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where('res.status_id=? AND res.arrival_date = ?',
           Ref::ReservationStatus[:RESERVED],  request_date)
  }

  # Scope for Calculating Actual Due In Room Count
  scope :due_in_already, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where('res.status_id=? AND res.arrival_date = ?',
           Ref::ReservationStatus[:CHECKEDIN],  request_date)
  }

  # Scope for Calculating Stay Over Room Count
  scope :stay_over_on, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where(is_occupied: true)
    .where('res.status_id=? AND res.dep_date > ? and res.arrival_date < ?',
           Ref::ReservationStatus[:CHECKEDIN],  request_date, request_date)
  }

  # Scope for Calculating Departure Room Count
  scope :departure_on, proc { |req_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where('res.dep_date = ?', req_date)
  }

  # Scope for calculating expected Stay Over + actual Stay Over (Valid for HOUSE KEEPING Future Counts) - CICO-8605
  scope :total_stay_over_on, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where('res.dep_date > ? and res.arrival_date < ?', request_date, request_date)
    .where('res.status_id != ?',
    Ref::ReservationStatus[:NOSHOW])
  }

  # Scope for calculating expected Departures + actual Departures (Valid for HOUSE KEEPING Future Counts) - CICO-8605
  scope :total_departure_on, proc { |request_date|
    joins('INNER JOIN reservation_daily_instances res_d_ins ON res_d_ins.room_id = rooms.id')
    .joins('INNER JOIN reservations res ON res.id = res_d_ins.reservation_id')
    .where('res.dep_date = ?', request_date)
    .where('res.status_id != ?',
    Ref::ReservationStatus[:NOSHOW])
  }

  # Scope for finding inactive rooms for the requested date - CICO-8620 - HK Story
  scope :out_of_order_between, proc { |from_date, to_date|
    joins(:inactive_rooms)
    .where('inactive_rooms.date >= ? and inactive_rooms.date <= ?', from_date, to_date)
    .where("inactive_rooms.ref_service_status_id = ?",
    Ref::ServiceStatus[:OUT_OF_ORDER]).uniq
  }

   # Scope for finding inactive rooms for the requested date - CICO-8620 - HK Story
  scope :inactive_between, proc { |from_date, to_date|
    joins(:inactive_rooms)
    .where('inactive_rooms.date >= ? and inactive_rooms.date <= ?', from_date, to_date)
    .where("inactive_rooms.ref_service_status_id = ? OR inactive_rooms.ref_service_status_id = ?",
    Ref::ServiceStatus[:OUT_OF_SERVICE], Ref::ServiceStatus[:OUT_OF_ORDER])
  }
  # Find the Blocked Rooms from the given Date Time Range
  # We need to list all the overlapping rooms in the list.
  scope :pre_reservations_between, proc { |from_date_time, to_date_time|
    joins(:pre_reservations)
    .where('from_time <= ? and to_time >= ?', to_date_time, from_date_time)
  }

  scope :vacant_and_dirty_rooms_on, proc { |req_date|
    with_hk_status('DIRTY').where('is_occupied = false')
  }

  scope :movable, -> { where(no_room_move: false) }

  scope :with_reservation_hk_statuses, proc { |statuses, date|
    conditions = []

    active_reservations_query = 'select distinct room_id from reservation_daily_instances ' \
                                'join reservations on reservations.id = reservation_daily_instances.reservation_id ' \
                                'where reservation_date = :date and reservations.hotel_id = rooms.hotel_id and room_id is not null '

    if statuses.include?('ARRIVALS')
      conditions << "rooms.id IN (#{active_reservations_query} " \
                    "and reservations.arrival_date = :date and reservations.status_id = :reserved)"
    end

    if statuses.include?('DEPARTED')
      conditions << "rooms.id IN (#{active_reservations_query} " \
                    "and reservations.dep_date = :date and reservations.status_id = :checked_out)"
    end

    if statuses.include?('ARRIVED')
      conditions << "rooms.id IN (#{active_reservations_query} " \
                    "and reservations.arrival_date = :date and reservations.status_id = :checked_in)"
    end

    if statuses.include?('STAYOVER')
      conditions << "rooms.id IN (#{active_reservations_query} " \
                    "and reservations.arrival_date < :date and reservations.dep_date > :date and reservations.status_id = :checked_in)"
    end

    if statuses.include?('DUEOUT')
      conditions << "rooms.id IN (#{active_reservations_query} " \
                    "and reservations.dep_date = :date and reservations.status_id = :checked_in)"
    end

    if statuses.include?('NOT_RESERVED')
      conditions << "rooms.id NOT IN (#{active_reservations_query} " \
                    'and reservations.status_id IN (:reserved, :checked_in, :checked_out))'
    end

    if statuses.include?('DAYUSE')
      conditions << "rooms.id IN (#{active_reservations_query} " \
                    "and reservations.arrival_date = :date and reservations.dep_date = :date)"
    end

    query = conditions.map { |condition| "(#{condition})" }.join(' OR ')

    where(query, date: date, reserved: Ref::ReservationStatus[:RESERVED].id, checked_in: Ref::ReservationStatus[:CHECKEDIN].id,
                 checked_out: Ref::ReservationStatus[:CHECKEDOUT].id)
  }

  # External OWS call for update room status
  def self.sync_external_room_status(hotel_id, room_type_id, room_no)
    logger.debug "Starting sync external room status method for hotel_id #{hotel_id}"
    room_api = RoomApi.new(hotel_id)
    hotel = Hotel.find(hotel_id)
    cleaned_rooms_during_import = []
    room_attributes = room_api.get_room_status('', room_no)
    if room_attributes[:status]
      room_attributes[:data].each do |attribute|
        # This flag is to identify whether room is active or not - CICO-10281
        # For each room iteration we should set is_active true - CICO-12128
        # if any rooms seems to OO/OO, we will set is_active into false.
        is_active = true

        previous_room_status_ready = true
        room = Room.find_by_hotel_id_and_room_no(hotel_id, attribute[:room_no])
        room_id = room.id if room.present?
        business_date = hotel.active_business_date
        if room
          if !room.hotel.is_pre_checkin_only? && !room.is_ready?
            previous_room_status_ready = false
          end
          # Check whether the room is inactive and get the record.
          existing_room = InactiveRoom.find_by_date_and_room_id(business_date, room_id)

          # IF a room is OO/OS in a pms connected hotel, then insert it in inactive rooms table
          if attribute[:hk_status] == "OO" || attribute[:hk_status] == "OS"
            begin
              # If room is OO/OS, set its corresponding service_status.
              (attribute[:hk_status] == "OO") ? (service_status_id = Ref::ServiceStatus[:OUT_OF_ORDER].id) : (service_status_id = Ref::ServiceStatus[:OUT_OF_SERVICE].id)
              if existing_room
                existing_room.update_attributes!(room_service_params(room_id, service_status_id, business_date))
              else
                InactiveRoom.create!(room_service_params(room_id, service_status_id, business_date))
              end
              logger.debug "Successfully added room #{attribute[:room_no]} to inactive rooms table"
              # Make the active flag false, since the room is inactive (OO/OS) - CICO-10281
              is_active = false
            rescue ActiveRecord::RecordInvalid
              logger.debug "Error in updating OO/OS room #{attribute[:room_no]} to inactive rooms table"
            end
          # Delete the room from inactive rooms, if hk status is neither OO nor OS.
          else
            existing_room.destroy if existing_room
          end
          unless room.update_attributes(hk_status: is_active ? attribute[:hk_status] : "DIRTY", is_occupied: attribute[:is_occupied])
            logger.warn "Could not save room with room number: #{attribute[:room_no]}: " + room.errors.full_messages
          else
            cleaned_rooms_during_import << room if !previous_room_status_ready && room.is_ready?
          end
        else
          logger.warn "Could not find room number: #{attribute[:room_no]}: "
        end
      end
      logger.debug " ********   cleaned rooms for checkin alert during room status import : #{cleaned_rooms_during_import.count}  ********"
      hotel.alert_due_in_guests_on_room_status_change(cleaned_rooms_during_import) unless cleaned_rooms_during_import.empty?
    end
  end

  def self.room_service_params(room_id, service_status_id, business_date)
    {
      room_id: room_id,
      ref_service_status_id: service_status_id,
      date: business_date
    }
  end

  def room_ready_notification
    if hotel.settings.checkin_alert_is_on && hotel.settings.checkin_alert_on_room_ready
      if !is_occupied && self.is_ready? && self.is_due_in?
        reservation = reservation_daily_instances.current_daily_instances(hotel.active_business_date).first.reservation
        notification = NotificationDetail.find_by_notification_id_and_notification_type_and_notification_section(reservation.id, Setting.notification_type[:reservation], Setting.notification_section_text[:check_in])
        NotificationDetail.create_reservation_notification(reservation, Setting.notification_section_text[:check_in], nil) unless notification
      end
    end
  end

  def self.booked_in_reservation_date_range(reservation, rooms)
    booked_rooms = Room.joins('INNER JOIN reservation_daily_instances ON rooms.id = reservation_daily_instances.room_id INNER JOIN reservations ON reservations.id = reservation_daily_instances.reservation_id')
    .where('(reservations.status_id in (:statuses) AND reservations.arrival_date >= :from_date AND reservations.dep_date <= :to_date)',
      statuses: [Ref::ReservationStatus[:RESERVED], Ref::ReservationStatus[:CHECKEDIN]],
      from_date: reservation.arrival_date,
      to_date: reservation.dep_date)
      .where('rooms.hotel_id = :hotel_id AND rooms.id IN (:room_ids)', room_ids: rooms.pluck(:id), hotel_id: reservation.hotel_id)

    booked_rooms
  end

  def self.preassigned_future_rooms_arrival_earlier_than(req_date, rooms)
    rooms = Room.joins('INNER JOIN reservation_daily_instances ON rooms.id = reservation_daily_instances.room_id INNER JOIN reservations ON reservations.id = reservation_daily_instances.reservation_id')
            .where('reservations.dep_date != reservation_date or reservations.dep_date = reservations.arrival_date')
            .where('reservation_date < :req_date', req_date: req_date)
            .where('rooms.id IN (?)', rooms.pluck(:id))
  end

  # def preassigned_future_reservations_arrival_earlier_than(req_date)
  #   reservations = reservation_daily_instances.exclude_dep_date.with_status(:RESERVED)
  #     .where('reservation_date < :req_date', req_date: req_date).map(&:reservation).uniq
  #   reservations.count > 0
  # end

  def self.movable_rooms(rooms)
    rooms.where('reservations.no_room_move = false')
  end

  def self.assigned_rooms(hotel, rooms)
    room_ids = rooms.pluck(:id)
    Room.joins('INNER JOIN reservation_daily_instances ON reservation_daily_instances.room_id = rooms.id '\
      'INNER JOIN reservations on reservations.id = reservation_daily_instances.reservation_id')
    .where('reservation_daily_instances.reservation_date >= :bus_date AND rooms.id in (:room_ids)', bus_date: hotel.active_business_date, room_ids: room_ids)
    .select('rooms.*, reservation_daily_instances.reservation_id as rdi_res_id, '\
      'reservation_daily_instances.status_id as rdi_status_id, reservations.arrival_date as arrival_date, '\
      'reservations.dep_date as dep_date, reservations.no_room_move as no_room_move, reservations.guarantee_type as guarantee_type')
  end

  def self.get_available_rooms(hotel, room_type = nil, exclude_room_id = nil, rooms = nil, reservation=nil)
    business_date = hotel.active_business_date
    if !rooms
      if room_type
        rooms = room_type.rooms.order(:room_no)
      else
        rooms = hotel.rooms.order(:room_no)
      end
    end
    hkstatuses = Ref::HousekeepingStatus.all.map { |r| {id: r.id, value: r.value } }

    if hotel.settings.checkin_inspected_only
      ready_status_ids = hkstatuses.select{|s| s[:value]=='INSPECTED'}
    else
      ready_status_ids = hkstatuses.select{|s| s[:value]=='INSPECTED' || s[:value]=='CLEAN'}
    end
    due_out_fo_status = Setting.room_fo_status[:dueout]
    occupied_fo_status = Ref::FrontOfficeStatus[:OCCUPIED].value
    vacant_fo_status = Ref::FrontOfficeStatus[:VACANT].value
    use_pickup = hotel.settings.use_pickup.to_s
    checkin_inspected_only = hotel.settings.checkin_inspected_only.to_s
    use_inspected = hotel.settings.use_inspected.to_s
    oo_service_status_id = Ref::ServiceStatus[:OUT_OF_SERVICE].id
    
    # TODO: This assumes that selection is on checking in day
    # TODO: Room assigned for current reservation wont be shown.
    # r1 = rooms.select do |room|
    #   (!room.is_occupied || room.is_due_out?) && (!room.is_due_in? || room.is_preassigned?) && room.id != exclude_room_id
    # end.map { |room| map_available_room_details(room, hotel) }
    # a1 =  r1.map {|r| r["room_id"]}
    
    # t1 = Time.now

    assigned_rooms = Room.assigned_rooms(hotel, rooms)
    
    due_out_rooms = assigned_rooms.where(is_occupied: true).where('reservations.dep_date = ? AND reservations.status_id = ?', 
                    reservation.arrival_date, Ref::ReservationStatus[:CHECKEDIN].id)
    due_out_room_ids = due_out_rooms.pluck(:id)
    assigned_reserved_rooms = assigned_rooms.where(is_occupied: false).where('reservations.status_id = ?', Ref::ReservationStatus[:RESERVED].id)
    assigned_reserved_room_ids = assigned_reserved_rooms.pluck(:id)
    due_in_rooms = assigned_reserved_rooms.where('reservations.arrival_date = ?', 
                    reservation.arrival_date)
    due_in_room_ids = due_in_rooms.pluck(:id)
    future_rooms_arriving_earlier_than_departure = assigned_reserved_rooms.where('reservations.arrival_date < ?', 
                    reservation.dep_date)
    preassigned_res_ids = future_rooms_arriving_earlier_than_departure.map{ |r| r[:rdi_res_id] }.uniq

    assigned_reserved_future_reservations = assigned_reserved_rooms.select {|r| r[:arrival_date] >= reservation.dep_date && r[:no_room_move] == false }.map{ |r| r[:rdi_res_id] }.uniq
    
    # Find the guest details for pre assigned future reservations    
    if !assigned_reserved_future_reservations.empty?
      preassigned_guests = GuestDetail.joins(:reservations_guest_details)
      .where('reservations_guest_details.reservation_id in (?) AND reservations_guest_details.is_primary=true', assigned_reserved_future_reservations)
      .select('guest_details.last_name as last_name, reservations_guest_details.reservation_id')
    end
    future_room_ids = future_rooms_arriving_earlier_than_departure.pluck(:id)
        
    movable_rooms = Room.movable_rooms(due_in_rooms.merge(future_rooms_arriving_earlier_than_departure))
    movable_room_ids = movable_rooms.pluck(:id)

    inactive_rooms = rooms.inactive_between(business_date, business_date).select('rooms.id as id, inactive_rooms.room_id as room_id, inactive_rooms.ref_service_status_id as ref_service_status_id')
    inactive_room_ids = inactive_rooms.pluck(:id)
    t1 = Time.now
    unavailable_room_ids = []

    rooms.each do |room|
      if room.id == exclude_room_id
        unavailable_room_ids << room.id
      end
      if room.is_occupied
        if !due_out_room_ids.include?(room.id)
          unavailable_room_ids << room
        end
      else
        if assigned_reserved_room_ids.include?(room.id)
          if due_in_room_ids.include?(room.id) || future_room_ids.include?(room.id)
            if !movable_room_ids.include?(room.id)
              unavailable_room_ids << room
            end
          end
        end
      end
    end

    rooms = rooms.where('rooms.id NOT in (?)', unavailable_room_ids) unless unavailable_room_ids.empty?

    room_features = Feature.joins('INNER JOIN rooms_features ON rooms_features.feature_id = features.id')
                    .where(hotel_id: hotel.id)
                    .where('rooms_features.room_id IN (?)', rooms.pluck(:id)).select('rooms_features.feature_id, features.*, rooms_features.room_id')

    
    rooms.map { |room| 
      # p Time.now - t1
      t1 = Time.now
      if inactive_room_ids.include?(room.id)
        service_status_id = inactive_rooms.select{ |r| r.id = room.id }.map{ |s| s.ref_service_status_id }.first
      end
      res_preassigned = assigned_reserved_room_ids.include?(room.id) && movable_room_ids.include?(room.id)
      if res_preassigned
        preassigned_reservation = assigned_reserved_rooms.select {|f| f[:id] == room.id}.map{ |r| r[:rdi_res_id]}.first
        last_name = preassigned_guests && preassigned_guests.select {|g| g[:reservation_id] == preassigned_reservation}.map {|gn| gn[:last_name]}.first
        guarantee_type = assigned_reserved_rooms.select {|f| f[:rdi_res_id] == preassigned_reservation}.map{|r| r[:guarantee_type]}.first
      end
      # map_available_room_details(room, hotel) 
      room_hash = {
        'room_id' => room.id,
        'room_number' => room.room_no,
        'room_max_occupancy' => room.max_occupancy,
        'room_status' => ready_status_ids.map{ |r| r[:id] }.include?(room.hk_status_id)  && !room.is_occupied ? 'READY' : 'NOTREADY',
        'fo_status' => due_out_room_ids.include?(room.id) ? due_out_fo_status : (room.is_occupied ? occupied_fo_status : vacant_fo_status),
        'is_preassigned' => res_preassigned,
        'room_features' => room_features.select {|f| f[:room_id] == room.id}.map{|r| r[:feature_id]},
        'room_ready_status' => hkstatuses.select{ |s| s[:id] == room.hk_status_id }.map{ |s| s[:value]}.first,
        'use_inspected' => use_inspected,
        'use_pickup' => use_pickup,
        'checkin_inspected_only' => checkin_inspected_only,
        'room_max_occupancy' => room.max_occupancy,
        'room_type_max_occupancy' => room_type.max_occupancy,
        'is_oos' => service_status_id == oo_service_status_id ? true : false,
        'last_name' => last_name,
        'guarantee_type' => guarantee_type
      }
      room_hash
    }
    # a2 =  r2.map {|r| r["room_id"]}
    # p a2 - a1
    # r2
  end

  # Returns the preassigned reservation
  def preassigned_reservation
    reservation_daily_instances.includes(:reservation).where('reservations.status_id = :status_id AND reservations.arrival_date = :business_date AND reservations.no_room_move = false',
                                                             business_date: hotel.active_business_date, status_id: Ref::ReservationStatus[:RESERVED]).first.andand.reservation
  end

  # Returns a list of preassigned reservations between the
  def preassigned_between(from_date, to_date)
    reservation_daily_instances.exclude_dep_date.with_status(:RESERVED)
      .where(':from_date <= reservation_date and reservation_date <= :to_date', from_date: from_date, to_date: to_date).map(&:reservation).uniq
  end

  # Checks if the room is available on each date within the range provided
  def available_between?(from_date, to_date)
    available = true

    (from_date..to_date).each do |business_date|
      available = self.available_on_date?(business_date) if available
    end

    available
  end

  # Checks if the room is not reserved on the business date
  def available_on_date?(business_date)
    !reservation_daily_instances.where('status_id in (:statuses) AND reservation_date = :business_date',
                                       business_date: business_date, statuses: [Ref::ReservationStatus[:RESERVED], Ref::ReservationStatus[:CHECKEDIN]]).exists?
  end

  # Checks if the room is available on each date within the range provided (must not be unmoveable)
  def unmoveable_between?(from_date, to_date)
    unmoveable = false

    (from_date..to_date).each do |business_date|
      unmoveable = self.unmoveable_on_date?(business_date) unless unmoveable
    end

    unmoveable
  end

  # Ensures no unmoveable rooms are reserved on the business date
  def unmoveable_on_date?(business_date)
    reservation_daily_instances.includes(:reservation)
    .where('reservations.no_room_move = true && reservation_daily_instances.status_id = :status_id
            AND reservation_daily_instances.reservation_date = :business_date',
           business_date: business_date, status_id: Ref::ReservationStatus[:RESERVED]).exists?
  end

  def self. map_available_room_details(room, hotel)
    is_preassigned = room.is_preassigned?

    room_hash = {
      # 'room' => room,
      'room_id' => room.id,
      # 'room_number' => room.room_no,
      # 'room_status' => room.is_ready? ? 'READY' : 'NOTREADY',
      # 'fo_status' => room.mapped_fo_status,
      # 'is_preassigned' => is_preassigned,
      # 'room_features' => room.features.pluck(:id),
      # 'room_ready_status' => room.andand.hk_status.to_s,
      # 'use_inspected' => hotel.settings.use_inspected.to_s,
      # 'use_pickup' => hotel.settings.use_pickup.to_s,
      # 'checkin_inspected_only' => hotel.settings.checkin_inspected_only.to_s,
      # 'room_max_occupancy' => room.max_occupancy,
      # 'room_type_max_occupancy' => room.room_type.max_occupancy,
      # 'is_oos' => (room.andand.service_status == Ref::ServiceStatus[:OUT_OF_SERVICE].id) ? true : false
      }
    # if is_preassigned
    #   reservation = room.preassigned_reservation
    #   room_hash['last_name'] = reservation.andand.primary_guest.andand.last_name.to_s
    #   room_hash['guarantee_type'] = reservation.andand.guarantee_type.to_s
    # end

    room_hash
  end

  def set_room_image_from_base64(base64_data)
    file_name = "room_image#{DateTime.now.strftime("%Y%m%d%H%M%S")}.png"
    image_path = Rails.root.join('public', file_name)
    File.open(image_path, 'wb') do |file|
      file.write(ActiveSupport::Base64.decode64(base64_data))
    end
    room_image = File.open(image_path)
    self.image = room_image
    File.delete(image_path)
  end

  # Returns whether room is due in or not. ie a reservation assigned to the room and is due in on hotel's business date.
  def is_due_in?
    reservation_daily_instances.includes(:reservation).where('reservations.status_id = :status_id AND reservations.arrival_date = :business_date',
                                                             business_date: hotel.active_business_date, status_id: Ref::ReservationStatus[:RESERVED]).exists?
  end

  # Returns whether or not the room is due out. This means there is a reservation assigned to the room that is due out on the hotel's business date.
  def is_due_out?
    is_occupied && reservation_daily_instances.includes(:reservation)
      .where('reservations.status_id = :status_id AND reservations.dep_date = :business_date',
             business_date: hotel.active_business_date, status_id: Ref::ReservationStatus[:CHECKEDIN]).exists?
  end

  def self.due_in_preassigned_movable_rooms(hotel, rooms)
    if hotel.settings.checkin_inspected_only
      hkstatus_id = [Ref::HousekeepingStatus[:INSPECTED].id]
    else
      hkstatus_id = [Ref::HousekeepingStatus[:INSPECTED].id, Ref::HousekeepingStatus[:CLEAN].id]
    end

    Room.joins('INNER JOIN reservation_daily_instances ON rooms.id = reservation_daily_instances.room_id INNER JOIN reservations on reservation_daily_instances.reservation_id = reservations.id')
      .where('reservations.hotel_id = :hotel_id AND reservations.status_id = :status_id AND reservations.arrival_date = :business_date AND reservations.no_room_move = false',
             business_date: hotel.active_business_date, status_id: Ref::ReservationStatus[:RESERVED], hotel_id: hotel.id)
      .where('rooms.id IN (?)', rooms.pluck(:id))
      .where('rooms.is_occupied = false')
      .where('hk_status_id IN (?)', hkstatus_id)

      # .select('reservation_daily_instances.room_id as rdi_room_id, rooms.id as room_id, reservations.arrival_date, rooms.is_occupied, reservations.status_id')
  end
  # Returns whether room is preassigned or not. ie a reservation assigned to the room and is due in on hotel's business date,
  # but the room is not occupied, it is ready, and the reservation is moveable.
  def is_preassigned?
    !is_occupied && self.is_ready? && reservation_daily_instances.includes(:reservation)
      .where('reservations.status_id = :status_id AND reservations.arrival_date = :business_date AND reservations.no_room_move = false',
             business_date: hotel.active_business_date, status_id: Ref::ReservationStatus[:RESERVED]).exists?
  end

  def is_preallocated?
    reservation_daily_instances.includes(:reservation)
      .where('reservations.status_id = :status_id AND reservations.arrival_date = :business_date AND reservations.no_room_move = false',
             business_date: hotel.active_business_date, status_id: Ref::ReservationStatus[:RESERVED]).exists?
  end

  # Return this value for managing UI
  def mapped_fo_status(due_out = is_due_out?)
    if due_out
      Setting.room_fo_status[:dueout]
    else
      is_occupied ? Ref::FrontOfficeStatus[:OCCUPIED].value : Ref::FrontOfficeStatus[:VACANT].value
    end
  end

  def is_ready?
    if hotel.settings.checkin_inspected_only
      hk_status === :INSPECTED && !is_occupied
    else
      (hk_status === :INSPECTED || hk_status === :CLEAN) && !is_occupied
    end
  end

  ############################## ***START*** HK Front office status handling for future dates ***START*** #####################

  def current_room_daily_instances_on(req_date)
    reservation_daily_instances.where(reservation_date: req_date)
  end

  def room_reservations_on(req_date)
    daily_instances = current_room_daily_instances_on(req_date)
    daily_instances.present? ? hotel.reservations.where('id in (?)', daily_instances.pluck(:reservation_id)).order(:arrival_date, :confirm_no) : []
  end

  def front_office_status_on(req_date)
    reservations = room_reservations_on(req_date)
    front_office_status_for_reservations(reservations)
  end

  ############################## ***END*** HK Front office status handling for future dates ***END*** ########################

  # Computed Status

  # count for reservations with active_business_date
  def current_room_daily_instances
    reservation_daily_instances.joins(:reservation).where(reservation_date: hotel.active_business_date)
      .with_status(:RESERVED, :CHECKEDIN, :CHECKEDOUT).order('reservations.arrival_date')
  end

  def room_reservations
    daily_instances = current_room_daily_instances
    daily_instances.present? ? hotel.reservations.where('id in (?)', daily_instances.pluck(:reservation_id)).order(:arrival_date, :confirm_no) : []
  end

  def front_office_status
    reservations = room_reservations
    front_office_status_for_reservations(reservations)
  end

  def front_office_status_for_reservations(reservations)
    count = reservations.count
    business_date = hotel.active_business_date

    return 'Not Reserved' if count == 0

    if count == 1
      reservation = reservations.first
      if reservation.is_stay_over_than?(business_date)
        return 'Stayover'
      elsif reservation.is_arrival_on?(business_date)
        return 'Arrival'
      elsif reservation.is_arrived_on?(business_date) && reservation.is_day_use_on?(business_date) && reservation.is_due_out_on?(business_date)
        return 'Arrived / Day use / Due out'
      elsif reservation.is_due_out_on?(business_date)
        return 'Due out'
      elsif reservation.is_arrived_on?(business_date)
        return 'Arrived'
      elsif reservation.is_early_checkout_than?(business_date) || reservation.is_no_show?
        return 'Not Reserved'
      elsif reservation.is_departed_on?(business_date)
        return 'Departed'
      else
        logger.debug "HK_Status - Not defined for #{room_no} of hotel id - #{hotel.id}"
        return 'Not Defined'
      end
    end

    if count >= 2
      first = reservations[0]
      second = reservations[1]

      if (first.is_departed_on?(business_date) && second.is_arrived_on?(business_date) && second.is_day_use_on?(business_date) && (first.is_due_out_on?(business_date) || second.is_due_out_on?(business_date))) || (second.is_departed_on?(business_date) && first.is_arrived_on?(business_date) && first.is_day_use_on?(business_date) && (first.is_due_out_on?(business_date) || second.is_due_out_on?(business_date)))
        return 'Arrived / Day Use / Due out / Departed'
      elsif (first.is_due_out_on?(business_date) || second.is_due_out_on?(business_date)) && (first.is_arrival_on?(business_date) || second.is_arrival_on?(business_date))
        return 'Due out / Arrival'
      elsif (first.is_departed_on?(business_date) || second.is_departed_on?(business_date)) && (first.is_arrival_on?(business_date) || second.is_arrival_on?(business_date))
        return 'Departed / Arrival'
      elsif (first.is_arrived_on?(business_date) || second.is_arrived_on?(business_date)) && (first.is_departed_on?(business_date) || second.is_departed_on?(business_date))
        return 'Arrived / Departed'
      elsif (first.is_departed_on?(business_date) || second.is_departed_on?(business_date)) && (first.is_due_out_on?(business_date) || second.is_due_out_on?(business_date))
        return 'Due out / Departed'
      elsif first.is_arrived_on?(business_date) || second.is_arrived_on?(business_date) # and self.room_reservations.any { |reservation| reservation.status_id == Ref::ReservationStatus[:CHECKEDOUT].id }
        return 'Arrived'
      elsif first.is_stay_over_than?(business_date) || second.is_stay_over_than?(business_date)
        return 'Stayover'
      elsif first.is_departed_on?(business_date) || second.is_departed_on?(business_date)
        return 'Departed'
      else
        logger.debug "HK_Status - Not defined for #{room_no} of hotel id - #{hotel.id}"
        return 'Not Defined'
      end
    end
  end

  def is_in_house?
    is_occupied && reservation_daily_instances.includes(:reservation).where('reservations.status_id = :status_id AND reservations.dep_date > :business_date',
                                                                            business_date: hotel.active_business_date, status_id: Ref::ReservationStatus[:CHECKEDIN]).exists?
  end

  def service_status
    room_service = self.inactive_rooms.where(date: hotel.active_business_date).first
    room_service.present? ? room_service.andand.ref_service_status_id : Ref::ServiceStatus[:IN_SERVICE].id
  end

  # Get service status on specified date - Return service status as string - This is the difference between above service status method and this one.
  def service_status_on(date)
    room_service = self.inactive_rooms.where(date: date).first
    room_service.present? ? room_service.andand.ref_service_status.to_s : Ref::ServiceStatus[:IN_SERVICE].to_s
  end

  private

  def get_default_room_image
    request = Thread.current[:current_request]
    image_url =  request.protocol + request.host_with_port + '/assets/default_room_type.jpg'
    image_url
  end

  
end
