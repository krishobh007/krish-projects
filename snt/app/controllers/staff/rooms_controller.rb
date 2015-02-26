class  Staff::RoomsController < ApplicationController
  before_filter :check_session, :retrieve
  after_filter :load_business_date_info
  before_filter :check_business_date

  # Get all rooms
  def available
    room_type = current_hotel.room_types.find_by_room_type(params[:room_type])
    p "Room status sync... #{Time.now}"
    t1 = Time.now
    Room.sync_external_room_status(current_hotel.id, params[:room_type], nil) if params[:refresh_rooms]
    p "Sync completed at #{Time.now}"
    business_date = current_hotel.active_business_date
    # t1 = Time.now
    total_rooms = room_type.rooms.exclude_pseudo
    out_of_order_rooms = total_rooms.out_of_order_between(business_date, business_date).pluck(:room_id)
    total_rooms_ids = total_rooms.pluck(:id)
    available_rooms = total_rooms_ids - out_of_order_rooms
    
    # Filter the rooms by applying additional query to remove out of order rooms for standalone hotels
    rooms = total_rooms.where("rooms.id IN (?)", available_rooms).get_available_rooms(current_hotel, room_type, @reservation.current_daily_instance.room_id, rooms, @reservation)
    
    # rooms = rooms.reject { |r| !r["room"].available_between?(@reservation.arrival_date, @reservation.dep_date) &&
    #                            r["room"].preassigned_future_reservations_arrival_earlier_than(@reservation.dep_date) && !@reservation.is_hourly }
    # t2 = Time.now
    # p t2 - t1
    reservation_occupancy = @reservation.current_daily_instance.total_guests
    render json: { status: SUCCESS, data: { rooms: rooms, reservation_occupancy: reservation_occupancy } , errors: [] }
  end

  private

  def retrieve
    @reservation = Reservation.find(params[:reservation_id])
  end
end
