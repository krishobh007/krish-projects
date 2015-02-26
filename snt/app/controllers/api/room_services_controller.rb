class Api::RoomServicesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  before_filter :retrieve, only: [:show, :update]
  
  def show
    
  end
  
  def create
    from_date = params[:from_date].to_date
    to_date = params[:to_date].to_date
    (from_date..to_date).each { |date|
      # Handle room unassignment when room service status is made OUT OF ORDER - CICO-10281 && CICO-8470
      unassign_out_of_order_room(params[:room_id], params[:room_service_status_id], date)
      # Check for an existing room
      existing_room = InactiveRoom.find_by_date_and_room_id(date, params[:room_id])
      if existing_room
        existing_room.update_attributes!(room_service_params(date))
      else
        InactiveRoom.create!(room_service_params(date))
      end
    }
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end
  
  def update
    errors = []
    from_date = params[:from_date].to_date if params[:from_date].present?
    to_date = params[:to_date].to_date if params[:to_date].present?
    is_room_status_in_service = (params[:room_service_status_id] == Ref::ServiceStatus[:IN_SERVICE].id)
    # When service status to be set to IN SERVICE, no need of from date, to date and maintenance reason.
    if @inactive_room.present?
      # Destroy the existing data.
      destroy_existing_data(from_date, to_date, is_room_status_in_service)
      unless is_room_status_in_service
        (from_date..to_date).each { |date|
        # Handle room unassignment when room service status is made OUT OF ORDER - CICO-10281 && CICO-8470
        unassign_out_of_order_room(params[:id], params[:room_service_status_id], date)
        # Check for an existing room
        InactiveRoom.create!(room_service_params(date))
      }
      end
    else
      errors << "Room not found"
      render(json: errors, status: :unprocessable_entity)
    end
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end
  
  # Lists all service status
  def status_list
    @service_status = Ref::ServiceStatus.page(params[:page]).per(params[:per_page])
  end
  
  # Unassign room from the reservation, if the same is set to OUT OF ORDER
  def unassign_out_of_order_room(room, service_status, date)
    if room.present? && service_status.present?
      if (service_status == Ref::ServiceStatus[:OUT_OF_ORDER].id)
        room = current_hotel.rooms.find(params[:room_id])
        room_reservation = room.room_reservations_on(date).first
        if room_reservation.present?
          room_reservation.daily_instances.update_all(room_id: nil) if room_reservation.status === :RESERVED
        end
      end 
    end
    rescue ActiveRecord::RecordInvalid => e
      render(json: e.record.errors.full_messages, status: :unprocessable_entity)
  end
  
  def inactive_rooms
    from_date = params[:begin_date].to_date
    to_date = params[:end_date].to_date
    rooms = current_hotel.rooms
    @inactive_rooms_hash = {}
    from_date.upto(to_date).each { |date|
      inactive_rooms = rooms.inactive_between(date, date)
      @inactive_rooms_hash[date.to_s] = inactive_rooms.map { |room| {room_id: room.id, room_no: room.room_no, service_status: room.service_status_on(date) }}
    } if from_date && to_date
    @inactive_rooms_hash
  end
  
  # Get the service status of the requested room for the requested dates - CICO-12520.
  def service_info
    from_date = params[:from_date].to_date
    to_date = params[:to_date].to_date
    room = Room.find(params[:room_id])
    is_room_in_service = false
    @room_service_details = {}
    service_status_hash = {}
    (from_date..to_date).each { |day|
      inactive_room =  room.inactive_rooms.find_by_date(day)
      # If inactive room is present, then get the record from DB, else it will be a IN SERVICE room
      # IN SERVICE rooms are not kept in DB - They are removed.
      if inactive_room.present?
        is_room_in_service = false
        service_status = inactive_room.andand.ref_service_status
      else
        is_room_in_service = true
        service_status = Ref::ServiceStatus[:IN_SERVICE]
      end
      service_status_hash = {:id => service_status.id, :value => service_status.to_s}
      
      # Append reason and comments to the hash only when room is OOO/OOS, 
      # IN SERVICE rooms will never have maintenance reason and comments.
      service_status_hash.merge!(:reason_id => inactive_room.andand.maintenance_reason_id, 
                             :comments => inactive_room.andand.comments) unless is_room_in_service
                             
      @room_service_details[day.to_s] = service_status_hash
    }
  end
  
  private

  # Retrieve the selected room entry
  def retrieve
    @date = params[:from_date] ? params[:from_date].andand.to_date : current_hotel.active_business_date
    room_service_data = get_inactive_room_details
    @inactive_room = room_service_data[:inactive_rooms].first if room_service_data[:inactive_rooms]
    @from_date = room_service_data[:from_date]
    @to_date = room_service_data[:to_date]
    render(json: [I18n.t(:no_rooms_found)], status: :unprocessable_entity) unless room_service_data.present? 
  end
  
  def room_service_params(date)
    {
      room_id: params[:room_id],
      ref_service_status_id: params[:room_service_status_id],
      date: date,
      maintenance_reason_id: params[:reason_id],
      comments: params[:comment]
    }
  end
  
 # Method to get from date and to date for the OO/OS rooms
  def get_inactive_room_details
    room_service_data = {}
    room = Room.find(params[:id])
    whole_inactive_rooms = room.inactive_rooms.where('date >= ? and date <= ?', params[:from_date], params[:to_date])
    if whole_inactive_rooms.present?
      room_service_data[:inactive_rooms] = whole_inactive_rooms.order(:date)
      room_service_data[:from_date] = room_service_data[:inactive_rooms].first.andand.date
      room_service_data[:to_date] = room_service_data[:inactive_rooms].last.andand.date
    end
    room_service_data
  end
  
  def destroy_existing_data(from_date, to_date, is_room_in_service)
    room = Room.find(params[:id])
    whole_inactive_rooms = room.inactive_rooms.where('date >= ? and date <= ?', from_date, to_date)
    whole_inactive_rooms.destroy_all
  end  
end