class StaffHouseKeeping::RoomsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date

  # Search for all rooms that match the criteria and return paginated list
  def search
    @business_date = current_hotel.active_business_date
    @date = params.key?(params[:date]) ? params[:date].to_date : @business_date
    @is_standalone = current_hotel.standalone_pms?

    @rooms = current_hotel.rooms.page(params[:page]).per(params[:per_page]).exclude_pseudo_and_suite.order(:room_no)

    filter_query
    filter_work
    filter_floor
    filter_room_type
    filter_housekeeping_status
    filter_room_status
    filter_front_office_status

    @reservations = current_hotel.reservations.joins(:daily_instances)
      .joins('LEFT OUTER JOIN reservations_guest_details ON reservations_guest_details.reservation_id = reservations.id')
      .where('reservations_guest_details.is_primary = true')
      .where('reservation_daily_instances.reservation_date = ?', @date)
      .where('reservation_daily_instances.room_id' => @rooms.map(&:id))
      .select('reservations.*, reservation_daily_instances.room_id, reservations_guest_details.guest_detail_id')
      .with_status(:RESERVED, :CHECKEDIN, :CHECKEDOUT).order(:arrival_date)

    @guests = GuestDetail.where(id: @reservations.map(&:guest_detail_id))
  end

  def room_details
    room_id = params[:room_id]
    status, data, errors = FAILURE, {}, []

    room = current_hotel.rooms.find(room_id)
    if current_hotel.is_third_party_pms_configured?
      # External pms call for getting room status
      ows_api = RoomApi.new(current_hotel.id)
      ows_response = ows_api.get_room_status(room.room_type.room_type, room.room_no)
      if ows_response[:status]
        room.hk_status = Ref::HousekeepingStatus[ows_response[:data].first[:hk_status]]
        room.is_occupied = ows_response[:data].first[:is_occupied]
        room.room_type_id = ows_response[:data].first[:room_type_id]
        room.save!
      else
        errors << I18n.t(:cannot_update_room_status)
      end
    end

    active_business_date = current_hotel.active_business_date

    reservation =  room.room_reservations
                  .where('status_id = ?', Ref::ReservationStatus[:CHECKEDIN].id).first if room.is_occupied? && !room.room_reservations.empty?

    primary_guest = reservation && room.is_occupied? ? reservation.andand.primary_guest : nil

    is_late_checkout_on = current_hotel.settings.late_checkout_is_on

    # As per CICO-5861, CICO-5891
    # List OO & OS DD in room detail screen if status is OO or OS
    # else list excluded status of OO & OS
    if room.hk_status === :OO || room.hk_status === :OS
      hk_status_list = mapped_hk_status_list(room)
    else
      hk_status_list = Ref::HousekeepingStatus.get_housekeeping_status_list(current_hotel.settings.use_inspected, current_hotel.settings.use_pickup)
    end

    data[:room_details]  = {}
    data[:room_details] = mapped_room(reservation, room, active_business_date, primary_guest, hk_status_list)
    data[:room_details][:room_reservation_hk_status] = room.service_status
    data[:room_details][:use_pickup] =  current_hotel.settings.use_pickup.to_s
    data[:room_details][:use_inspected] =  current_hotel.settings.use_inspected.to_s
    data[:room_details][:checkin_inspected_only] =  current_hotel.settings.checkin_inspected_only.to_s
    if is_late_checkout_on
      data[:room_details][:is_late_checkout]  = reservation.andand.is_opted_late_checkout.to_s
      data[:room_details][:late_checkout_time] = reservation.andand.late_checkout_time.andand.strftime('%l:%M %p').to_s
    else
      data[:room_details][:is_late_checkout]  = 'false'
    end

    status = SUCCESS
    respond_to do |format|
      format.json { render json: { status: errors.empty? ? SUCCESS : FAILURE, errors: errors, data: data } }
    end
  end

  def change_house_keeping_status
    house_keeping_status_id = params[:hkstatus_id]
    room_no = params[:room_no]

    status, data, errors = FAILURE, {}, []

    if room_no.present? && house_keeping_status_id.present?
      hk_status = Ref::HousekeepingStatus.find(house_keeping_status_id)
      if current_hotel && current_hotel.is_third_party_pms_configured?
        # PMS call for updating change

        hk_status_api = RoomApi.new(current_hotel.id)
        result = hk_status_api.change_room_status(hk_status.description, room_no)

        if result[:status]
          previous_room_status_ready = true
          # update status in snt database.
          room = current_hotel.rooms.where(room_no: room_no).first
          if !room.hotel.is_pre_checkin_only? && !room.is_ready?
            previous_room_status_ready = false
          end
          room.hk_status = hk_status
          is_saved = room.save
          room.hotel.alert_due_in_guests_on_room_status_change([room]) if is_saved && !previous_room_status_ready && room.is_ready?
          status = SUCCESS
        else
          status = FAILURE
          errors << I18n.t(:external_pms_failed)
        end
      else
        room = current_hotel.rooms.where(room_no: room_no).first
        room.hk_status = hk_status
        room.save!
        status = SUCCESS

      end
    else
      errors << I18n.t(:missing_parameters, attribute: 'Room No / House Keeping Status')
      status = FAILURE
    end

    respond_to do |format|
      format.json { render json: { status: status, errors: errors, data: data } }
    end
  end

  private

  def map_floor_data(floor_id, floor_number)
    {
      id: floor_id,
      floor_number: floor_number
    }
  end

  # Used this method for displaying a single room details.
  def mapped_room(reservation, room, active_business_date, primary_guest, hk_status_list)
    work_sheet_id = room.andand.work_sheets.where(:date => active_business_date).first.andand.id
    assigned_task_completion_status = room.andand.work_assignments
                             .where(work_sheet_id: work_sheet_id).first.andand.task.andand.ref_housekeeping_status
    task_completion_status = assigned_task_completion_status.present? ? assigned_task_completion_status : Ref::HousekeepingStatus[:CLEAN]
    {
      id: room.id,
      current_room_no: room.room_no.to_s,
      is_occupied: room.is_occupied.to_s,
      current_hk_status: room.hk_status ? room.hk_status.to_s.upcase : 'Not Defined',
      current_room_reservation_status: room.andand.front_office_status.to_s.upcase,
      hk_status_list: hk_status_list,

      avatar_src: primary_guest ? primary_guest.andand.avatar.andand.url(:thumb).to_s : '',
      is_vip: primary_guest ? primary_guest.andand.is_vip.to_s : '',
      guest_name: primary_guest ? primary_guest.andand.full_name.to_s : '',
      reservation_status: reservation && room.is_occupied? ? ViewMappings::StayCardMapping.map_view_status(reservation, active_business_date) : '',
      is_ready: (room.is_ready?).to_s,
      dept_date:  reservation.andand.dep_date.andand.strftime('%Y-%m-%d').to_s,
      room_type: {id: room.room_type.id,
      name: room.room_type.room_type_name},
      floor: floor_details(room),
      task_ids: room.andand.room_type.tasks.pluck(:id),
      arrival_time: reservation.andand.arrival_time.andand.strftime("%I:%M %P"),
      departure_time: reservation.andand.departure_time.andand.strftime("%I:%M %P"),
      assigned_maid: room.andand.work_sheets.where(:date => active_business_date).first.andand.user.andand.full_name,
      work_sheet_id: work_sheet_id,
      work_status: WorkAssignment.joins(:room, :work_sheet)
                                 .where('rooms.id = ? AND work_sheets.date = date(?)', room.id, active_business_date)
                                 .first.andand.work_status.andand.value,
      task_completion_status: task_completion_status.to_s,
      task_completion_status_id: task_completion_status ? task_completion_status.id : nil
    }
  end

  def mapped_hk_status_list(room)
    [
      id: room.hk_status.id,
      value: room.hk_status.value.to_s,
      description: room.hk_status.description.to_s.titleize,
      ext_description: room.hk_status.description.to_s
    ]
  end

  def floor_details(room)
    {
      id: room.andand.floor.andand.id,
      floor_number: room.andand.floor.andand.floor_number
    }
  end

  # Filter by room number query if provided
  def filter_query
    query = params[:query]
    @rooms = @rooms.where('room_no like ?', "%#{query}%") if query.present?
  end

  # Filter work
  def filter_work
    if @is_standalone
      work_type_id = params[:work_type_id]
      assignee_id = params[:assignee_id]
      show_all_employees = params[:all_employees_selected]

      # Filter by Work Type
      if work_type_id.present?
        @rooms = @rooms.where('room_type_id in (select distinct room_type_tasks.room_type_id from room_type_tasks ' \
                              'join tasks on tasks.id = room_type_tasks.task_id where tasks.work_type_id = :work_type_id)',
                              work_type_id: work_type_id)
      end

      if assignee_id.present?
        employee_id = assignee_id
      elsif current_user.floor_maintenance_staff? && work_type_id.present? && !show_all_employees
        employee_id = current_user.id
      end

      # Filter by Work Sheet Assignee
      if employee_id.present?
        @rooms = @rooms.joins('left outer join work_assignments on work_assignments.room_id = rooms.id')
          .joins('left outer join work_sheets on work_sheets.id = work_assignments.work_sheet_id')
          .where('work_sheets.date' => @date, 'work_sheets.user_id' => employee_id)
      end
    end
  end

  # Filter by floor number
  def filter_floor
    floor_start = params[:floor_start]
    floor_end = params[:floor_end]

    if floor_start.present? && floor_end.present?
      @rooms = @rooms.joins(:floor).where('floors.floor_number >= ? and floors.floor_number <= ?', floor_start, floor_end)
    end
  end

  # Filter by room types
  def filter_room_type
    room_type_ids = params[:room_type_ids]
    @rooms = @rooms.where(room_type_id: room_type_ids.map { |room_type_id| room_type_id.to_i }) if room_type_ids.present?
  end

  # Filter by house keeping statuses
  def filter_housekeeping_status
    housekeeping_statuses = params[:house_keeping_status]

    if housekeeping_statuses.present?
      # For standalone hotels, the OOS/OOO status is stored in the inactive rooms service status for today
      status_ids = (housekeeping_statuses & %W(DIRTY CLEAN PICKUP INSPECTED)).map { |status| Ref::HousekeepingStatus[status].id }

      in_service = status_ids.present?
      inactive = (housekeeping_statuses & %W(OO OS)).present?
      out_of_order = housekeeping_statuses.include?('OO')
      out_of_service = housekeeping_statuses.include?('OS')

      service_status_ids = []
      service_status_ids += [nil, Ref::ServiceStatus[:IN_SERVICE].id] if in_service
      service_status_ids << Ref::ServiceStatus[:OUT_OF_ORDER].id if out_of_order
      service_status_ids << Ref::ServiceStatus[:OUT_OF_SERVICE].id if out_of_service

      conditions = []

      if in_service
        conditions << 'hk_status_id IN (:status_ids) AND ' \
                      '(select count(*) from inactive_rooms where inactive_rooms.room_id = rooms.id and inactive_rooms.date = :date ' \
                      'and ref_service_status_id != :in_service) = 0'
      end

      if inactive
        conditions << '(select count(*) from inactive_rooms where inactive_rooms.room_id = rooms.id and inactive_rooms.date = :date ' \
                      'and ref_service_status_id IN (:service_status_ids)) > 0'
      end

      hk_query = conditions.map { |condition| "(#{condition})" }.join(' OR ')

      @rooms = @rooms.where(hk_query, status_ids: status_ids, date: @date, service_status_ids: service_status_ids,
                                      in_service: Ref::ServiceStatus[:IN_SERVICE].id)
    end
  end

  # Filter by room status
  def filter_room_status
    room_statuses = params[:reservation_status]

    if room_statuses.present?
      vacant = room_statuses.include?('VACANT')
      occupied = room_statuses.include?('OCCUPIED')
      queued = room_statuses.include?('QUEUED')

      conditions = []

      if vacant && !occupied
        conditions << 'is_occupied = false'
      elsif !vacant && occupied
        conditions << 'is_occupied = true'
      end

      if queued
        conditions << 'rooms.id in (select distinct room_id from reservation_daily_instances ' \
                      'join reservations on reservations.id = reservation_daily_instances.reservation_id ' \
                      'where reservation_daily_instances.reservation_date = :date and reservations.is_queued = true ' \
                      'and reservations.hotel_id = :hotel_id)'
      end

      room_status_query = conditions.map { |condition| "(#{condition})" }.join(' OR ')

      @rooms = @rooms.where(room_status_query, date: @date, hotel_id: current_hotel.id)
    end
  end

  # Filter by front office status
  def filter_front_office_status
    front_office_statuses = params[:front_office_status]

    if front_office_statuses.present?
      # Map input statuses to hk statuses
      statuses = []
      statuses << 'NOT_RESERVED' if front_office_statuses.include?('NOT_RESERVED')
      statuses << 'STAYOVER' if front_office_statuses.include?('STAY_OVER')
      statuses << 'ARRIVALS' if front_office_statuses.include?('ARRIVAL')
      statuses << 'ARRIVED' if front_office_statuses.include?('ARRIVED')
      statuses << 'DAYUSE' if front_office_statuses.include?('DAY_USE')
      statuses << 'DUEOUT' if front_office_statuses.include?('DUE_OUT')
      statuses << 'DEPARTED' if front_office_statuses.include?('DEPARTED')

      @rooms = @rooms.with_reservation_hk_statuses(statuses, @date)
    end
  end
end
