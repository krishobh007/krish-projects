class Guest::WakeupsController < ApplicationController
  before_filter :check_session
  # Method to return the wakeup calls for popup
  def wakeup_calls
    reservation_id = params[:reservation_id]
    selected_reservation = Reservation.find(reservation_id)
    @wakeup_calls = selected_reservation.get_wakeup_time
    respond_to do |format|
      format.json { render json: { status: SUCCESS , data: @wakeup_calls, errors: [] } }
    end
  end

  # Method to update or create wakeup calls to a reservation
  def add_or_update_wakeup_calls
    is_clear = false
    data = {}
    reservation_id = params[:reservation_id]
    selected_reservation = Reservation.find(reservation_id)
    params[:reservation_id] =  selected_reservation.id
    params[:hotel_id] = selected_reservation.hotel_id
    params[:user_id] = current_user.id
    params[:id] = selected_reservation.wakeups.first.id if selected_reservation.wakeups.present?
    current_hotel  = Hotel.find(selected_reservation.hotel_id) if selected_reservation.hotel_id
    if params.value?('')
      [:wake_up_time, :day].each { |key| params.delete(key) }
      is_clear = true
    end
    @data = selected_reservation.add_or_update_wakeup(params, current_hotel)
    if @data
      data = { day: @data.start_date, time: @data.time.strftime('%I:%M %p'), id: @data.id.to_s }  unless is_clear
      data = { day: '', time: '', id: '' } if is_clear
      render json: { status: SUCCESS , data: data, errors: [] }
    else
      render json: { status: FAILURE , data: {}, errors: [I18n.t(:unable_to_update_wakeup)] }
    end
  end
end
