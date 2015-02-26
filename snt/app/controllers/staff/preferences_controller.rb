class Staff::PreferencesController < ApplicationController
  before_filter :check_session
  after_filter :load_business_date_info
  before_filter :check_business_date
  def likes
    guest = GuestDetail.find(params[:user_id])
    @data = current_hotel.get_guest_features_hash(guest)
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: { status: SUCCESS, data: @data, errors: [] } }
    end
  end

  def room_assignment
  
    is_allow_previous_room_types = true
    reservation = Reservation.find(params[:reservation_id])
    room_filters = ViewMappings::FeaturesMapping.map_room_filters(reservation, current_hotel, is_allow_previous_room_types)
    respond_to do |format|
      format.html { render layout: false }
      format.json { render json: { status: SUCCESS, data: room_filters, errors: nil } }
    end
  end
end
