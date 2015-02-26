class Api::HourlyOccupancyController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  def index
    @room_types = current_hotel.room_types.is_not_pseudo
    @rooms = current_hotel.rooms.where(room_type_id: @room_types.pluck(:id))

    business_date = current_hotel.active_business_date
    arrival_date = params[:begin_date] ? params[:begin_date] : business_date
    dep_date = params[:end_date] ? params[:end_date] : business_date + 1.day
    begin_datetime = getDatetime(arrival_date, params[:begin_time], current_hotel.tz_info).utc
    end_datetime = getDatetime(dep_date, params[:end_time], current_hotel.tz_info).utc
    # Get the occupancy details for the reservations which has room assign.
    reservations = current_hotel.reservations.occupancy(begin_datetime, end_datetime)
    @occupancy_result = construct_formatted_occupancy_result(reservations)
  end

  private

  def construct_formatted_occupancy_result(reservations)
    occupancy_hash = {}
    occupancy_hash[:occupancy] = []
    reservations.each do |reservation|
      occupancy_hash[:occupancy] << occupancy_hash(reservation)
    end
    occupancy_hash[:occupancy]
  end

  def occupancy_hash(reservation)
    current_daily_instance = reservation.current_daily_instance(reservation.arrival_date)
    arrival_time = reservation.arrival_time if reservation.arrival_time
    arrival_time = arrival_time.in_time_zone(reservation.hotel.tz_info).strftime('%H:%M') if reservation.arrival_time
    departure_time = reservation.departure_time.present? ? reservation.departure_time.in_time_zone(reservation.hotel.tz_info) : nil
    departure_time = departure_time.strftime('%H:%M') if reservation
    reservation_payment_method = reservation.valid_primary_payment_method if reservation
    {
      reservation_id: reservation.id,
      confirmation_number: reservation.confirm_no,
      reservation_status: ViewMappings::StayCardMapping.map_view_status(reservation, reservation.hotel.active_business_date).to_s,
      room_id: current_daily_instance.andand.room_id,
      reservation_primary_guest_full_name: reservation.primary_guest.andand.full_name,
      arrival_date: reservation.arrival_date,
      arrival_time: arrival_time,
      # As per CICO-13076 - we will send departure date as departure_time date
      # departure_time set to actual system time, during the checkout of Hourly Reservations.
      departure_date:  reservation.departure_time.to_date,
      departure_time: departure_time,
      room_service_status:  Ref::ServiceStatus[current_daily_instance.andand.room.andand.service_status].to_s,
      hk_status: current_daily_instance.andand.room.andand.hk_status.to_s,
      guest_id: reservation.andand.primary_guest.andand.id,
      company_id: reservation.company_id,
      travel_agent_id: reservation.travel_agent_id,
      company_card_name: reservation.andand.company.andand.account_name,
      travel_agent_name: reservation.andand.travel_agent.andand.account_name,
      adults: current_daily_instance.andand.adults,
      infants: current_daily_instance.andand.infants,
      children: current_daily_instance.andand.children,
      payment_type: reservation_payment_method.andand.id,
      payment_method_used: reservation_payment_method.andand.payment_type.andand.value.andand.upcase,
      payment_method_description: reservation_payment_method.andand.payment_type.andand.description.to_s,
      payment_details: ViewMappings::StayCardMapping.map_payment_details(reservation),
      accompanying_guests: ViewMappings::StayCardMapping.map_reservation_accompanying_guests(reservation)
   }
  end

  def getDatetime(date, time, tz_info)
    ActiveSupport::TimeZone[tz_info].parse(date.to_s + ' ' + time.to_s)
  end
end
