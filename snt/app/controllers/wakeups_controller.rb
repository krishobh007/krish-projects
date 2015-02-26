class WakeupsController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  # Method to return the wakeup calls for popup
  def wakeup_calls
    reservation_id = params[:reservation_id]
    selected_reservation = Reservation.find(reservation_id)
    @wakeup_calls = selected_reservation.get_wakeup_time
    @wakeup_calls[:reservation_status] = ViewMappings::StayCardMapping.map_view_status(selected_reservation, current_hotel.active_business_date)
    respond_to do |format|
      format.html { render partial:  'modals/setWakeUpCall' }
      format.json { render json: { status: 'success', data: @wakeup_calls, errors: [] } }
    end
  end

  # Method to update or create wakeup calls to a reservation
  def add_or_update_wakeup_calls
    reservation_id = params[:reservation_id]
    selected_reservation = Reservation.find(reservation_id)
    params[:reservation_id] =  selected_reservation.id
    params[:hotel_id] = selected_reservation.hotel_id
    params[:user_id] = current_user.id
    params[:id] = selected_reservation.wakeups.first.id if selected_reservation.wakeups.present?
    @data = selected_reservation.add_or_update_wakeup(params, current_hotel)
    if @data
      render json: { status: SUCCESS , data: [], errors: [] }
    else
      render json: { status: FAILURE , data: [], errors: ['Unable to Add/Update Wakeup call'] }
    end
  end
end
